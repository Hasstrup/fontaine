# frozen_string_literal: true

module Queries
  # The Engine module provides a structure for executing queries against
  # a given model with a defined set of parameters and conditions.
  module Engine
    # Calls the engine with the provided keyword arguments.
    #
    # @param [Hash] kwargs The keyword arguments for initialization.
    # @return [Object] The result of the engine call.
    def self.call(**kwargs)
      new(**kwargs).call
    end

    # Initializes a new instance of the Engine with sanitized parameters.
    #
    # @param [Hash] params The parameters for the query.
    # @param [Symbol] type The type of query (default is :group).
    # @return [void]
    def initialize(params:, type: :group)
      @params = params.sanitize!
      @type = type
    end

    # Executes the query and handles success or failure.
    #
    # @return [Context] The context containing the result of the query.
    def call
      safely_execute do
        relation = scope!(klass.where(params.conditions).includes(params.includes))
        raise ActiveRecord::RecordNotFound if single? && relation&.empty?

        context.succeed(single? ? relation.first : relation)
      end
    end

    private

    attr_reader :params, :type

    # Returns the model class for the query. Must be implemented by the including class.
    #
    # @raise [NotImplementedError] If not implemented in a subclass.
    def klass
      raise NotImplementedError
    end

    # Checks if the query type is :single.
    #
    # @return [Boolean] True if the type is :single; otherwise, false.
    def single?
      type == :single
    end

    # Applies any scopes to the relation before executing the query.
    #
    # @param [ActiveRecord::Relation] relation The relation to scope.
    # @return [ActiveRecord::Relation] The scoped relation.
    def scope!(relation)
      relation
    end
  end
end
