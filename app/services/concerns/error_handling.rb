# frozen_string_literal

module ErrorHandling
  module Core
    ERROR_CLASSES = [
      ActiveRecord::RecordNotFound,
      ActiveRecord::RecordInvalid,
      ActiveModel::UnknownAttributeError,
      ActiveRecord::StatementInvalid,
      BaseService::InvalidInputError,
      BaseService::ServiceError
    ]

    def safely_execute(&block)
      run_checks! if should_run_checks?
      block.call
      context
    rescue *ERROR_CLASSES => e
      fail!(error: e)
    end

    def run_checks!
      raise NotImplementedError
    end
  end

  module Validatable
    module ClassMethods
      def performs_checks
        @should_run_checks = true
      end

      attr_reader :should_run_checks
    end

    def should_run_checks?
      self.class.should_run_checks
    end

    def self.included(base)
      base.include(Core)
      base.extend(ClassMethods)
    end

    def run_checks!
      raise BaseService::InvalidInputError, input.errors.flat_map(&:message) unless input.valid?
    end

    def raise_error!(message)
      raise BaseService::ServiceError, message
    end
  end
end
