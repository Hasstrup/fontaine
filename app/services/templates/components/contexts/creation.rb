# frozen_string_literal: true

class Templates::Components::Contexts::Creation < BaseService
  performs_checks

  def initialize(input:)
    @input = input
  end

  def call
    safely_execute do
      succeed(::Templates::Component.create!(**input.to_h.except(:user_id)))
    end
  end
end
