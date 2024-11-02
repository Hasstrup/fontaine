# frozen_string_literal: true

module Templates
  module Templates
    module Contexts
      module Generation
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
                parsed_document = persist_doc!(parsed_template_instructions)
                PDFKit.new(File.open(parsed_document.path), format: :html).to_html
              end
            ensure
              tempfile.close
            end

            private

            attr_reader :template

            def parsed_template_instructions
              template.instructions.each_value do |instructions|
                page = document.pages.add
                ::PDF::Pages::Builder.build!(page, instructions)
              end
              document
            end

            def persist_doc!(document)
              document.write(tempfile.path)
              tempfile
            end

            def tempfile
              @tempfile ||= Tempfile.new(template.reference_file_name)
            end

            def document
              @document ||= HexaPDF::Document.new
            end
          end
        end
      end
    end
  end
end
