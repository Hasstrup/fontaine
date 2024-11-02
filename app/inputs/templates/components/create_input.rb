# frozen_string_literal: true

module Templates
  module Components
    class CreateInput < BaseInput
      REQUIRED_KEYS = %i[key_tags key_type text_accessor template_id user_id]
      attributes(:title, *REQUIRED_KEYS)

      def validate!
        validate_required_keys!
        validate_template!
        validate_user!
      end

      private

      def validate_template!
        within_error_context do
          validate_association!(template_id, ::Templates::Template)
        end
      end

      def validate_user!
        within_error_context do
          validate_association!(user_id, ::User)
          validate_template_ownership!
        end
      end

      def validate_template_ownership!
        within_error_context do
          pipe_error(restricted_access_error) unless user_template_exists?
        end
      end

      def user_template_exists?
        ::Templates::Template.exists?(user_id:, id: template_id)
      end
    end
  end
end
