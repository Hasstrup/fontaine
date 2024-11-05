# frozen_string_literal: true
# frozen_string_literal: true

# The Authentication class is responsible for handling user authentication.
# It verifies the provided credentials and generates an authentication token
# upon successful authentication.
class Users::Contexts::Authentication < BaseService
  class InvalidCredentialsError < ServiceError
    # Returns an error message for invalid credentials.
    #
    # @return [String] The error message.
    def message
      'Incorrect username/password combination'
    end
  end

  performs_checks

  # Initializes a new Authentication context.
  #
  # @param [Users::AuthenticationInput] input The input object containing authentication credentials.
  # @return [void]
  def initialize(input:)
    @input = input
  end

  # Executes the authentication logic, checking the user's credentials.
  #
  # @return [Context] The context with success or failure information.
  def call
    safely_execute do
      user.authenticate(input.password) ? succeed(authentication_token) : fail!(error: invalid_credentials_error)
    end
  end

  private

  attr_reader :input

  # Finds the user by their email address.
  #
  # @return [User] The authenticated user.
  # @raise [ActiveRecord::RecordNotFound] If the user is not found.
  def user
    @user ||= ::User.find_by!(email: input.email)
  end

  # Creates an authentication token for the user.
  #
  # @return [Tokens::AuthenticationToken] The created authentication token.
  def authentication_token
    @authentication_token ||= Tokens::AuthenticationToken.create!(
      owner: user,
      token: Encryption::TokenManager.payload_2_token(data: { id: user.id }) # really basic payload
    )
  end

  # Generates an error for invalid credentials.
  #
  # @return [InvalidCredentialsError] The error indicating invalid credentials.
  def invalid_credentials_error
    InvalidCredentialsError.new
  end
end
