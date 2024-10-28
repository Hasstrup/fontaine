# frozen_string_literal: true

module Encryption
  class TokenManager
    PAYLOAD_KEY = 'data'
    SIGNING_KEY = 'SIGNING_SECRET'
    class << self
      def payload_2_token(*args)
        JWT.encode(*args, signing_key)
      end

      def token_2_payload(token)
        JWT.decode(token, signing_key, true).first[PAYLOAD_KEY] if token
      rescue JWT::ExpiredSignature, ActiveSupport::MessageEncryptor::InvalidMessage
        nil
      end

      def signing_key
        ENV.fetch(SIGNING_KEY, '')
      end
    end
  end
end
