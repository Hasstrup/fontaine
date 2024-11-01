# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authorization
  include ResponseHelpers

  def ensure_current_user!
    error_response('You are not authorised. Please login', :unauthorized) unless current_user
  end
end
