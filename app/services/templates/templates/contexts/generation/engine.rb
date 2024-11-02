# frozen_string_literal: true

module Templates
  module Templates
    module Contexts
      module Generation
        class Engine < BaseService
          HTML_GENERATION_STRATEGIES = %i[pdfkit hexapdf]

          def initialize(template_id, strategy)
            @template_id = template_id
            @strategy = strategy
          end

          def run
            safely_execute do
              PDFKit.new(modified_doc.to_html).to_file(tmpfile.path)
              succeed(tmpfile)
            end
          end

          private

          attr_reader :template_id, :strategy

          def template
            @template ||=
              ::Templates::Template.includes(:components, :user).find(template_id)
          end

          def modified_doc
            @modified_doc ||= template.components.reduce(document) do |document, component|
              key_type_applicator_for(component).apply!(component, document)
            end
          end

          def original_html_content
            @original_html_content ||=
              basic_strategy? ? template.html_content : Strategies::HexaPdf.generate_html_content(content)
          end

          def key_type_applicator_for(component)
            "::Templates::Components::KeyTypeApplicator::#{component.key_type.to_s.camelize}Applicator".constantize
          end

          def document
            @document ||= Nokogiri::HTML(original_html_content)
          end

          def tmpfile
            @tmpfile ||= Tempfile.new(template.reference_file_name)
          end

          def basic_strategy?
            strategy == HTML_GENERATION_STRATEGIES.first
          end
        end
      end
    end
  end
end
