# frozen_string_literal: true

module Templates
  module KeyTypeApplicators
    module Invoices
      class TotalHoursApplicator < ::Templates::KeyTypeApplicators::Base
        def apply!
          selector.content = current_value if apply_changes?
          document
        end

        private

        def apply_changes?
          key_tags.length && current_value
        end
      end
    end
  end
end
