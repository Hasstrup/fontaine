# frozen_string_literal: true

class Templates::ComponentsController < ApplicationController
  before_action :ensure_current_user!

  def create
    ctx = ::Templates::Components::Contexts::Creation.call(input: component_create_input)
    return error_response(ctx.message) unless ctx.success?

    render json: ::Templates::ComponentBlueprint.render(ctx.payload), status: :created
  end

  def show
    context = Templates::Components::Contexts::Fetch.call(params: component_query_params, type: :single)
    return error_response(context.message) unless context.success?

    render json: Templates::ComponentBlueprint.render(context.payload), status: :ok
  end

  def index
    context = Templates::Components::Contexts::Fetch.call(params: component_query_params)
    return error_response(context.message) unless context.success?

    render json: Templates::ComponentBlueprint.render(context.payload), status: :ok
  end

  private

  COMPONENT_PARAM_KEYS = %i[title key_type text_accessor template_id]

  def component_query_params
    @component_query_params ||= ::Templates::Components::QueryInput.new(fields: params.permit!.to_h)
  end

  def component_create_input
    @component_create_input ||=
      ::Templates::Components::CreateInput.new(**including_current_user(template_component_params))
  end

  def template_component_params
    @template_component_params ||=
      params.require(:component).permit(*COMPONENT_PARAM_KEYS, key_tags: []).to_h
  end
end
