# frozen_string_literal: true

module Templates
  module Components
    module KeyTypeApplicators
      class DateApplicator < ::Templates::Components::KeyTypeApplicators::Base
        DATE_GAP = 30.days
        # extracts the current value from the contained html
        # tries to compute the next value, and update the html value
        #
        def apply!
          selector.content = computed_value if apply_changes?
          document
        end

        private

        def apply_changes?
          key_tags.length && current_value && computed_value
        end

        def computed_value
          @computed_value ||= if current_value
                                (Date.parse(current_value) + DATE_GAP)
                                  .strftime('%a, %b %e, %Y') # european conventional date format for all invoices
                              end
        end
      end
    end
  end
end
