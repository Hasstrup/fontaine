# frozen_string_literal: true

module Users
  class RegistrationInput < BaseInput
    REQUIRED_KEYS = %i[email password]
    attributes(*REQUIRED_KEYS, :first_name, :last_name)

    def validate!
      validate_required_keys!
    end
  end
end
