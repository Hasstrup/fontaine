# frozen_string_literal: true

module Templates
  module Templates
    module Contexts
      module PdfGeneration
        module Strategies
          class HexaPdf < BaseService
            def self.generate_html_content(*args)
              new(*args).generate_html_content
            end

            # @return [Strategies]
            def initialize(template)
              @template = template
            end

            # @return [String]
            def generate_html_content
              safely_execute do
                tmpfile = Tempfile.new(template.reference_file_name)
                parse_template_instructions(document).write(tempfile.path)
                PDFKit.new(File.open(tmpfile.path), format: :html).to_html
              ensure
                tmpfile.close
              end
            end

            private

            attr_reader :template

            def parse_template_instructions(document)
              template.instructions.each_value do |instructions|
                page = document.pages.add
                ::PDF::Pages::Builder.build!(page, instructions)
              end
              document
            end
          end
        end
      end
    end
  end
end
