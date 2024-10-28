# frozen_string_literal: true

class UsersController < ApplicationController
  def register
    context = ::Users::Contexts::Registration.call(
      input: ::Users::RegistrationInput.new(**registration_params)
    )
    return error_response(context.message) unless context.success?

    render json: ::Tokens::TokenBlueprint.render(context.payload), status: :ok
  end

  def authenticate
    context = ::Users::Contexts::Authentication.call(
      input: ::Users::AuthenticationInput.new(**authentication_params)
    )
    return error_response(context.message) unless context.success?

    render json: ::Tokens::TokenBlueprint.render(context.payload), status: :ok
  end

  def show
    context = ::Users::Contexts::Fetch.call(
      params: Users::QueryInput.new(fields: params.permit!.to_h),
      type: :single
    )
    return error_response(context) unless context.success?

    render json: UserBlueprint.render(context.payload), status: :ok
  end

  private

  def authentication_params
    @authentication_params ||= params.require(:user).permit(:email, :password)
  end

  def registration_params
    @registration_params ||=
      params.require(:user).permit(*%i[email first_name last_name email password])
  end
end
