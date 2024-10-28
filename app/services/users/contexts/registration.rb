# frozen_string_literal: true

module Users
  module Contexts
    class Registration < BaseService
      performs_checks

      def initialize(input:)
        @input = input
      end

      def call
        safely_execute do
          ActiveRecord::Base.transaction do
            succeed(authentication_token)
          end
        end
      end

      private

      def authentication_token
        @authentication_token ||= Tokens::AuthenticationToken.create!(
          owner: user,
          token: Encryption::TokenManager.payload_2_token({ id: user.id }) # simple documentation
        )
      end

      def user
        @user ||= User.create!(**input.to_h)
      end
    end
  end
end
