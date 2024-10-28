# frozen_string_literal: true

class BaseInput
  class InputValidationError < StandardError; end
  include Validation

  class << self
    attr_reader :fields, :target

    def attributes(*args)
      @fields = args
    end

    def input_for(target_klass)
      @target = target_klass
    end
  end

  attr_reader :errors

  def initialize(**kwargs)
    @input = OpenStruct.new(**kwargs.except(:context))
    @context = kwargs[:context]
    @valid = false
    @errors = []
  end

  def humanized_error_messages
    errors.map(&:message).join(', ')
  end

  def method_missing(name, *_args)
    input.send(name)
  end

  def respond_to_missing?(name, _include_private = false)
    self.class.attributes.include?(name)
  end

  def fetch(*args)
    to_h.fetch(*args)
  end

  def slice(*args)
    to_h.slice(*args)
  end

  delegate :to_h, to: :input

  private

  attr_reader :input, :valid, :context
end
