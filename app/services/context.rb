# frozen_string_literal: true

class Context
  attr_reader :success, :errors, :messages, :payload

  def initialize
    @success = true
    @errors = []
    @messages = []
  end

  def fail!(error:)
    @success = false
    @errors = [error]

    self
  end

  def succeed(payload = nil)
    clear_errors
    @success = true
    @payload = payload

    self
  end

  def payload!(payload:)
    @errors = []
    @payload = payload
  end

  # See if you can remove this
  def success?
    @success
  end

  def message
    success ? messages.join(', ') : errors.map(&:message).join(', ')
  end

  private

  def clear_errors
    @errors = []
  end
end
