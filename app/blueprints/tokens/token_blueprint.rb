# frozen_string_literal: true

module Tokens
  class TokenBlueprint < Blueprinter::Base
    fields :token, :created_at

    association :owner, blueprint: lambda(&:blueprint), default: {}, name: :user
  end
end
