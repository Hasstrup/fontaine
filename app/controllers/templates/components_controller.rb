# frozen_string_literal: true

module Templates
  class ComponentsController < ApplicationController
    before_action :ensure_current_user!

    def create
      ctx = ::Templates::Components::Contexts::Creation.call(
        input: ::Templates::Components::CreateInput.new(**
          template_component_params.merge(user_id: current_user.id))
      )
      return error_response(ctx.messge) unless ctx.success?

      render json: ::Templates::ComponentBlueprint.render(ctx.payload), status: :created
    end

    def show
      context = Templates::Components::Contexts::Fetch.call(
        params: ::Templates::Components::QueryInput.new(fields: params.permit!.to_h),
        type: :single
      )
      return error_response(context) unless context.success?

      render json: Templates::ComponentBlueprint.render(context.payload), status: :ok
    end

    def index
      context = Templates::Components::Contexts::Fetch.call(
        params: ::Templates::Components::QueryInput.new(fields: params.permit!.to_h)
      )
      return error_response(context) unless context.success?

      render json: Templates::ComponentBlueprint.render(context.payload), status: :ok
    end

    private

    COMPONENT_PARAM_KEYS = %i[title key_type text_accessor template_id]

    def template_component_params
      @template_component_params ||=
        params.require(:component).permit(*COMPONENT_PARAM_KEYS, key_tags: []).to_h
    end
  end
end
