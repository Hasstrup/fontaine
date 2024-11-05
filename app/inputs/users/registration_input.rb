# frozen_string_literal: true

class Users::RegistrationInput < BaseInput
  REQUIRED_KEYS = %i[email password].freeze
  attributes(*REQUIRED_KEYS, :first_name, :last_name)

  def validate!
    validate_required_keys!
  end
end
