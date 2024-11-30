# frozen_string_literal: true

class Templates::Components::Contexts::Fetch < BaseService
  include Queries::Engine

  private

  def klass = ::Templates::Component
end
