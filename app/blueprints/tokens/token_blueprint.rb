# frozen_string_literal: true

module Tokens
  class TokenBlueprint < Blueprinter::Base
    fields :token, :created_at

    association :owner, blueprint: ->(owner) { owner.blueprint }, default: {}, name: :user
  end
end
