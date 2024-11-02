# frozen_string_literal: true

module Templates
  module Templates
    module Contexts
      module Generation
        class Engine < BaseService
          HTML_GENERATION_STRATEGIES = %i[pdfkit hexapdf]

          def initialize(template_id, strategy = :pdfkit)
            @template_id = template_id
            @strategy = strategy
          end

          def run
            # get the the components belonging to the template
            # depending on the strategy, generate the right html
            #
          end

          private

          attr_reader :template_id, :strategy

          def template
            @template ||=
              ::Templates::Template.includes(:components, :user).find(template_id)
          end

          def usable_html_content
            return template.html_conent if basic_strategy?

            ::Strategies::HexaPdf.generate_html_content(template)
          end

          def basic_strategy?
            strategy == :pdfkit
          end
        end
      end
    end
  end
end
