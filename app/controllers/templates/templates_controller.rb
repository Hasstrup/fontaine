# frozen_string_literal: true

module Templates
  class TemplatesController < ApplicationController
    before_action :ensure_current_user!

    def create
      context = ::Templates::Templates::Contexts::Creation.call(
        input: ::Templates::Templates::CreateInput.new(**
          template_params.merge(user_id: current_user.id))
      )
      return error_response(context.messge) unless context.success?

      render json: ::Templates::TemplateBlueprint.render(context.payload), status: :created
    end

    def show
      context = Templates::Templates::Contexts::Fetch.call(
        params: ::Templates::Templates::QueryInput.new(fields: params.permit!.to_h),
        type: :single
      )
      return error_response(context) unless context.success?

      render json: Templates::TemplateBlueprint.render(context.payload), status: :ok
    end

    private

    TEMPLATE_KEYS = %i[title file_name file_base64].freeze

    def template_params
      @template_params ||=
        params.require(:template).permit(*TEMPLATE_KEYS).to_h
    end
  end
end
