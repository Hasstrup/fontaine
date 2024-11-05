# frozen_string_literal: true

module Templates
  module Components
    module KeyTypeApplicators
      class TotalApplicator < ::Templates::Components::KeyTypeApplicators::Base
        def apply!
          selector.content = computed_value if apply_changes?
          document
        end

        private

        def computed_value
          @computed_value ||= inject_currency((total_hours * unit_price).to_f)
        end

        def inject_currency(total)
          "#{currency}#{total}"
        end

        def apply_changes?
          current_value && total_hours && unit_price
        end

        def extract_hours
          hours_match = str.match(/(\d+):\d+:\d+/)[1]
          hours_match[1].to_i if hours_match
        end

        def total_hours
          @total_hours ||= extract_hours(
            TotalHoursApplicator.new(component_for(:total_hours), html).current_value
          )
        end

        def unit_price
          @unit_price ||= extract_price_and_currency(
            UnitPriceApplicator.new(component_for(:unit_price), html).current_value
          )
        end

        def extract_price_and_currency(_price_string)
          price_match = str.match(/(\p{Sc})(\d+),\d+/)
          return unless price_match

          @currency = price_match[1]
          price_match[2].to_i if price_match
        end
      end
    end
  end
end
