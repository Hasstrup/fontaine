# frozen_string_literal: true

class UsersController < ApplicationController
  def register
    context = ::Users::Contexts::Registration.call(input: users_registration_input)
    return error_response(context.message) unless context.success?

    render json: ::Tokens::TokenBlueprint.render(context.payload), status: :ok
  end

  def authenticate
    context = ::Users::Contexts::Authentication.call(input: users_authentication_input)
    return error_response(context.message) unless context.success?

    render json: ::Tokens::TokenBlueprint.render(context.payload), status: :ok
  end

  def show
    context = ::Users::Contexts::Fetch.call(params: query_users_params, type: :single)
    return error_response(context.message) unless context.success?

    render json: UserBlueprint.render(context.payload), status: :ok
  end

  private

  def users_registration_input
    @users_registration_input ||= ::Users::RegistrationInput.new(**registration_params)
  end

  def users_authentication_input
    @users_authentication_input ||= ::Users::AuthenticationInput.new(**authentication_params)
  end

  def query_users_params
    @query_users_params ||= Users::QueryInput.new(fields: params.permit!.to_h)
  end

  def authentication_params
    @authentication_params ||= params.require(:user).permit(:email, :password).to_h
  end

  def registration_params
    @registration_params ||=
      params.require(:user).permit(*%i[email first_name last_name email password]).to_h
  end
end
