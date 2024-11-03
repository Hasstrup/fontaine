# frozen_string_literal: true

module Users
  module Contexts
    class Authentication < BaseService
      class InvalidCredentialsError < ServiceError
        def message
          'Incorrect username/password combination'
        end
      end

      performs_checks

      def initialize(input:)
        @input = input
      end

      def call
        safely_execute do
          user.authenticate(input.password) ? succeed(token) : fail!(error: invalid_credentials_error)
        end
      end

      private

      attr_reader :input

      def user
        @user ||= ::User.find_by!(email: input.email)
      end

      def authentication_token
        @authentication_token ||= Tokens::AuthenticationToken.create!(
          owner: user,
          token: Encryption::TokenManager.payload_2_token({ id: user.id }) # really basic payload
        )
      end

      def invalid_credentials_error
        InvalidCredentialsError.new
      end
    end
  end
end
