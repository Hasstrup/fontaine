# frozen_string_literal: true

module Templates
  module Invoices
    class CreateInput < BaseInput
      REQUIRED_KEYS = %i[title file_name file_base64 user_id]
      attributes(*REQUIRED_KEYS)

      def validate!
        validate_required_keys!
        validate_user!
      end

      private

      def validate_user!
        within_error_context do
          validate_association!(user_id, User)
        end
      end
    end
  end
end
