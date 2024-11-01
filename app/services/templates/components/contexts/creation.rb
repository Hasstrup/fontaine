# frozen_string_literal: true

module Templates
  module Components
    module Contexts
      class Creation < BaseService
        def initialize(input:)
          @input = input
        end

        def call
          safely_execute do
            succeed(::Templates::Component.create!(**input.to_h))
          end
        end
      end
    end
  end
end
