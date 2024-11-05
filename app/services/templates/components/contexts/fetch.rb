# frozen_string_literal: true

module Templates
  module Components
    module Contexts
      class Templates::Components::Contexts::Fetch < BaseService
        include Queries::Engine

        private

        def klass = ::Templates::Component
      end
    end
  end
end
