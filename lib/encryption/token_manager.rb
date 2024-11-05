# frozen_string_literal: true

# The TokenManager class is responsible for encoding and decoding JWT tokens.
# It provides methods to convert payloads into tokens and retrieve payloads from tokens.
class Encryption::TokenManager
  PAYLOAD_KEY = 'data'
  SIGNING_KEY = 'SIGNING_SECRET'

  class << self
    # Encodes a payload into a JWT token.
    #
    # @param [Hash] args The payload to be encoded.
    # @return [String] The encoded JWT token.
    def payload_2_token(*args)
      JWT.encode(*args, signing_key)
    end

    # Decodes a JWT token and retrieves the payload.
    #
    # @param [String] token The JWT token to decode.
    # @return [Hash, nil] The decoded payload if the token is valid; otherwise, nil.
    def token_2_payload(token)
      JWT.decode(token, signing_key, true).first[PAYLOAD_KEY] if token
    rescue JWT::ExpiredSignature, ActiveSupport::MessageEncryptor::InvalidMessage
      nil
    end

    # Retrieves the signing key from the environment variables.
    #
    # @return [String] The signing key used for encoding and decoding tokens.
    def signing_key
      ENV.fetch(SIGNING_KEY, '')
    end
  end
end
