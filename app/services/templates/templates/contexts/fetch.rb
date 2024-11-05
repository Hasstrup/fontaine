# frozen_string_literal: true

class Templates::Templates::Contexts::Fetch < BaseService
  include Queries::Engine

  private

  def klass = ::Templates::Template
end
