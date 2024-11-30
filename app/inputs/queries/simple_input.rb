# frozen_string_literal: true

module Queries
  # The SimpleInput class is used for encapsulating query parameters and providing utility methods
  # for filtering and processing those parameters based on the target class's attributes and associations.
  class SimpleInput
    attr_reader :params

    class << self
      attr_reader :target_klass

      # Specifies the target class for which input parameters will be validated.
      #
      # @param [Class] klass The target class.
      # @return [void]
      def input_for(klass)
        @target_klass = klass
      end
    end

    # Initializes a new SimpleInput instance.
    #
    # @param [Hash] fields The input fields for the query.
    # @param [Symbol] type The type of query (default is :group).
    # @param [Hash] context Additional context for the query.
    # @return [void]
    def initialize(fields:, type: :group, **context)
      @params = fields
      @type = type
      @_context = context || {}
    end

    # Returns the conditions for the query based on valid fields.
    #
    # @return [Hash] A hash containing the sanitized query conditions.
    def conditions
      params.slice(*valid_fields)
    end

    # Returns the included associations based on the valid includes.
    #
    # @return [Array<Symbol>] An array of symbols representing included associations.
    def includes
      params[:includes]&.map(&:to_sym) & valid_includes
    end

    # Returns the context wrapped in an OpenStruct.
    #
    # @return [OpenStruct] The context object.
    def context
      @context ||= OpenStruct.new(**@_context)
    end

    # Sanitizes the parameters by removing keys with nil values.
    #
    # @return [Queries::SimpleInput] The current instance for chaining.
    def sanitize!
      # for now just remove nil keys
      params.compact!
      self
    end

    # Checks if the query type is :single.
    #
    # @return [Boolean] True if the type is :single; otherwise, false.
    def single?
      type == :single
    end

    # Returns the raw parameters wrapped in an OpenStruct.
    #
    # @return [OpenStruct] The raw parameters object.
    def __raw__
      OpenStruct.new(**params)
    end

    private

    attr_reader :type

    # Returns valid fields based on the target class's attributes.
    #
    # @return [Array<Symbol>] An array of valid field names.
    def valid_fields
      self.class.target_klass.attribute_names.map(&:to_sym)
    end

    # Returns valid includes based on the target class's associations.
    #
    # @return [Array<Symbol>] An array of valid association names.
    def valid_includes
      self.class.target_klass.reflect_on_all_associations.map(&:name)
    end
  end
end
