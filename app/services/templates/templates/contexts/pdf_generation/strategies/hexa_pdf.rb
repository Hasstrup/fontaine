# frozen_string_literal: true

module Templates::Templates::Contexts::PdfGeneration::Strategies
  # The HexaPdf class is responsible for generating HTML content from a template
  # using the HexaPDF library. It processes the template instructions and converts
  # them into an HTML representation suitable for PDF generation.
  class HexaPdf < BaseService
    # Generates HTML content from a template using HexaPDF.
    #
    # @param [Object] template The template object containing instructions.
    # @return [String] The generated HTML content.
    def self.generate_html_content(*args)
      new(*args).generate_html_content
    end

    # Initializes a new instance of the HexaPdf class.
    #
    # @param [Object] template The template object containing instructions.
    # @return [void]
    def initialize(template)
      @template = template
    end

    # Generates the HTML content from the template.
    #
    # @return [String] The generated HTML content.
    def generate_html_content
      safely_execute do
        tmpfile = Tempfile.new(template.reference_file_name)
        parse_template_instructions(document).write(tmpfile.path)
        PDFKit.new(File.open(tmpfile.path), format: :html).to_html
      ensure
        tmpfile.close
      end
    end

    private

    attr_reader :template

    # Parses the template instructions and builds the document.
    #
    # @param [Object] document The document object to which instructions are applied.
    # @return [Object] The document with parsed instructions.
    def parse_template_instructions(document)
      template.instructions.each_value do |instructions|
        page = document.pages.add
        ::Pdf::Pages::Builder.build!(page, instructions)
      end
      document
    end
  end
end
