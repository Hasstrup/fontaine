# frozen_string_literal: true

module Templates
  module Templates
    class EmailDispatchInput < BaseInput
      REQUIRED_KEYS = %i[strategy user_id template_id]
      attributes(*REQUIRED_KEYS)

      def validate!
        validate_required_keys!
      end
    end
  end
end
