# frozen_string_literal: true

module Templates
  module Templates
    module Contexts
      class Fetch < BaseService
        include Queries::Engine

        private

        def klass
          ::Templates::Template
        end
      end
    end
  end
end
