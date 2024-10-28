# frozen_string_literal: true

module Users
  class AuthenticationInput < BaseInput
    REQUIRED_KEYS = %i[email password]
    attributes(*REQUIRED_KEYS)

    def validate!
      validate_required_keys!
    end
  end
end
