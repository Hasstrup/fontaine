# frozen_string_literal: true

class Users::AuthenticationInput < BaseInput
  REQUIRED_KEYS = %i[email password].freeze
  attributes(*REQUIRED_KEYS)

  def validate!
    validate_required_keys!
  end
end
