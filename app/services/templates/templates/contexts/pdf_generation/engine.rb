# frozen_string_literal: true

module Templates
  module Templates
    module Contexts
      module PdfGeneration
        class Engine < BaseService
          HTML_GENERATION_STRATEGIES = %i[pdfkit hexapdf]

          def self.run(*args)
            new(*args).run
          end

          # @param [Integer] template_id
          # @param [pdfkit | hexapdf] strategy specifies the library for pdf generation
          # @return [Templates::Templates::Contexts::Generation::Engine]
          def initialize(template_id, strategy)
            @template_id = template_id
            @strategy = strategy
          end

          def run
            safely_execute do
              modified_document = template.components.reduce(original_html_doc) do |document, component|
                key_type_applicator_for(component).apply!(component, document)
              end
              PDFKit.new(modified_document.to_html).to_file(tmpfile.path)
              succeed(tmpfile.read)
            ensure
              tmpfile.close
            end
          end

          private

          attr_reader :template_id, :strategy

          def template
            @template ||= ::Templates::Template.includes(:components, :user).find(template_id)
          end

          def key_type_applicator_for(component)
            "::Templates::Components::KeyTypeApplicator::#{component.key_type.to_s.camelize}Applicator".constantize
          end

          def tmpfile
            @tmpfile ||= Tempfile.new(template.reference_file_name)
          end

          def original_html_doc
            @original_html_doc ||= Nokogiri::HTML(
              basic_strategy? ? template.html_content : Strategies::HexaPdf.generate_html_content(content)
            )
          end

          def basic_strategy?
            strategy == :pdfkit
          end
        end
      end
    end
  end
end
