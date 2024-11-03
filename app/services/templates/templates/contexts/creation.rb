# frozen_string_literal: true

module Templates
  module Templates
    module Contexts
      # The Creation service is responsible for creating a template from a given PDF file.
      #
      # It extracts instructions from the PDF, converts the PDF to HTML, and prepares parameters
      # for template creation.
      #
      # @see Templates::Invoices::CreateInput for the expected input structure.
      class Creation < BaseService
        # Initializes a new Creation service instance.
        #
        # @param [Templates::Invoices::CreateInput] input The input data containing file details and other attributes.
        # @return [void]
        def initialize(input:)
          @input = input
          @pages_instructions_map = {}
        end

        # Processes the PDF file, extracting instructions and converting it to HTML.
        #
        # @return [String] The HTML string content of the PDF.
        def call
          safely_execute do
            after_extracting_pdf_instructions do
              succeed(::Templates::Template.create!(**template_create_params))
            end
          ensure
            tmpfile.close
          end
        end

        private

        attr_reader :pages_instructions_map

        # Prepares parameters for creating a template.
        #
        # @return [Hash] A hash containing parameters for template creation.
        def template_create_params
          {
            reference_file_name: input.file_name,
            title: input.title,
            html_content: template_html_content,
            instructions: pages_instructions_map,
            user_id: input.user_id
          }
        end

        # Converts the PDF content to HTML.
        #
        # @return [String] The converted HTML content of the PDF.
        def template_html_content
          @template_html_content ||=
            PDFKit.new(File.open(tmpfile.path), format: :html).to_html
        end

        # Extracts instructions from the PDF pages and yields to the block.
        #
        # @yield [void] Yields control to the block after extraction is complete.
        def after_extracting_pdf_instructions
          reader.pages.each.with_index do |page, index|
            receiver = ::PDF::Reader::RegisterReceiver.new
            page.walk(receiver)
            pages_instructions_map[index + 1] =
              # the first entry specifies the page number, redundant to save it.
              receiver.callbacks[1..receiver.callbacks.length].to_s
          end
          yield
        end

        # Initializes a PDF reader for the provided file.
        #
        # @return [PDF::Reader] The PDF reader instance.
        def reader
          @reader ||= ::PDF::Reader.new(file.path)
        end

        # Creates a temporary file to hold the decoded PDF content.
        #
        # @return [Tempfile] The temporary file containing the PDF content.
        def tmpfile
          @tmpfile ||= begin
            tmp = Tempfile.new(input.file_name)
            tmp.binmode
            tmp.write(Base64.decode64(input.file_base64))
            tmp
          end
        end
      end
    end
  end
end
