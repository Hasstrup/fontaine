# frozen_string_literal: true

module Templates
  module Templates
    module Contexts
      class Creation < BaseService
        # @param [Templates::Invoices::CreateInput] input
        # @return [::Templates::Templates::Contexts::Creation]
        def initialize(input:)
          @input = input
          @pages_instructions_map = {}
        end

        # takes a file, converts to html
        # @return [String] the html string content of the pdf
        def call
          safely_execute do
            after_extracting_pdf_instructions do
              succeed(create_template!)
            end
          end
        end

        private

        attr_reader :pages_instructions_map

        def create_template!
          ::Templates::Template.create!(
            reference_file_name: input.file_name,
            title: input.title,
            html_content: template_html_content,
            instructions: pages_instructions_map,
            user_id: input.user_id
          )
        end

        def template_html_content
          @template_html_content ||=
            PDFKit.new(File.open(file.path), format: :html).to_html
        end

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

        def reader
          @reader ||= ::PDF::Reader.new(file.path)
        end

        def file
          @file ||= begin
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
