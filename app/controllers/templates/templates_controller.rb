# frozen_string_literal: true

class Templates::TemplatesController < ApplicationController
  before_action :ensure_current_user!

  def create
    context = ::Templates::Templates::Contexts::Creation.call(input: template_create_input)
    return error_response(context.messge) unless context.success?

    render json: ::Templates::TemplateBlueprint.render(context.payload), status: :created
  end

  def show
    context = Templates::Templates::Contexts::Fetch.call(params: query_template_params, type: :single)
    return error_response(context.message) unless context.success?

    render json: Templates::TemplateBlueprint.render(context.payload), status: :ok
  end

  def dispatch_mail
    context = ::Templates::Templates::Contexts::EmailDispatch.call(input: email_dispatch_input)
    return error_response(context.message) unless context.success?

    render json: ::Templates::TemplateBlueprint.render(context.payload), status: :created
  end

  private

  TEMPLATE_KEYS = %i[title file_name file_base64].freeze

  def template_create_input
    @template_create_input ||=
      ::Templates::Templates::CreateInput.new(**template_params.merge(user_id: current_user.id))
  end

  def query_template_params
    @query_template_params ||= ::Templates::Templates::QueryInput.new(fields: params.permit!.to_h)
  end

  def email_dispatch_input
    @email_dispatch_input ||=
      ::Templates::Templates::EmailDispatchInput.new(**including_current_user(template_mail_dispatch_params))
  end

  def template_mail_dispatch_params
    @template_mail_dispatch_params ||= params.permit(*%i[template_id strategy])
  end

  def template_params
    @template_params ||= params.require(:template).permit(*TEMPLATE_KEYS).to_h
  end
end
