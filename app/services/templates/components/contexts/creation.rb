# frozen_string_literal: true

class Templates::Components::Contexts::Creation < BaseService
  def initialize(input:)
    @input = input
  end

  def call
    safely_execute do
      succeed(::Templates::Component.create!(**input.to_h))
    end
  end
end
