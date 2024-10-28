# frozen_string_literal: true

module Users
  module Contexts
    class Fetch < BaseService
      include Queries::Engine

      private

      def klass
        ::User
      end
    end
  end
end
