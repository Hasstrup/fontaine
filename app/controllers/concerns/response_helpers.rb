# frozen_string_literal: true

module ResponseHelpers
  extend ActiveSupport::Concern

  def not_found_response
    response_format('Record not found', :not_found)
  end

  def error_response(message, status = :bad_request)
    response_format(message, status)
  end

  def success_response(message, status = :ok)
    response_format(message, status)
  end

  private

  def response_format(message, status)
    render json: { message: }, status:
  end
end
