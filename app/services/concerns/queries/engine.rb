# frozen_string_literal: true

module Queries
  module Engine
    def self.call(**kwargs)
      new(**kwargs).call
    end

    def initialize(params:, type: :group)
      @params = params.sanitize!
      @type = type
    end

    def call
      safely_execute do
        relation = scope!(klass.where(params.conditions).includes(params.includes))
        raise ActiveRecord::RecordNotFound if single? && relation&.empty?

        context.succeed(single? ? relation.first : relation)
      end
    end

    private

    attr_reader :params, :type

    def klass
      raise NotImplementedError
    end

    def single?
      type == :single
    end

    def scope!(relation)
      relation
    end
  end
end
