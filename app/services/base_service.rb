# frozen_string_literal: true

class BaseService
  class ServiceError < StandardError; end
  class InvalidInputError < StandardError; end
  include ErrorHandling::Validatable

  def self.call(**kwargs)
    new(**kwargs).call
  end

  def call
    raise NotImplementedError
  end

  delegate :fail!, :succeed, to: :context

  private

  attr_reader :input

  def context
    @context ||= Context.new
  end
end
