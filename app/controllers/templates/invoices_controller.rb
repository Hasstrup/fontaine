# frozen_string_literal: true

module Templates
  class InvoicesController < ApplicationController
    before_action :ensure_current_user!

    def create
      context = ::Templates::Invoices::Contexts::Creation.call(
        input: ::Templates::Invoices::CreateInput.new(**
          invoice_params.merge(user_id: current_user.id))
      )
      return error_response(context.messge) unless context.success?

      render json: ::Templates::InvoiceBlueprint.render(context.payload), status: :created
    end

    def show
      context = Templates::Invoices::Contexts::Fetch.call(
        params: ::Templates::Invoices::QueryInput.new(fields: params.permit!.to_h),
        type: :single
      )
      return error_response(context) unless context.success?

      render json: Templates::InvoiceBlueprint.render(context.payload), status: :ok
    end

    private

    INVOICE_KEYS = %i[title file_name file_base64]

    def invoice_params
      @invoice_params ||=
        params.require(:invoice).permit(*INVOICE_PARAMS).to_h
    end
  end
end
