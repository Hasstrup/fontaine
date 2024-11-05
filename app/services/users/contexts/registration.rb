# frozen_string_literal: true

# The Registration class handles the user registration process.
# It validates input and creates a new user in the database,
# generating an authentication token upon successful registration.
class Users::Contexts::Registration < BaseService
  performs_checks

  # Initializes a new Registration context.
  #
  # @param [Users::RegistrationInput] input The input object containing registration details.
  # @return [void]
  def initialize(input:)
    @input = input
  end

  # Executes the registration logic, creating a new user and an authentication token.
  #
  # @return [Context] The context with success or failure information.
  def call
    safely_execute do
      ActiveRecord::Base.transaction do
        succeed(authentication_token)
      end
    end
  end

  private

  # Creates an authentication token for the newly registered user.
  #
  # @return [Tokens::AuthenticationToken] The created authentication token.
  def authentication_token
    @authentication_token ||= Tokens::AuthenticationToken.create!(
      owner: user,
      token: Encryption::TokenManager.payload_2_token({ id: user.id }) # Generates a token using the user's ID.
    )
  end

  # Creates a new user from the provided input.
  #
  # @return [User] The newly created user object.
  def user
    @user ||= User.create!(**input.to_h)
  end
end
