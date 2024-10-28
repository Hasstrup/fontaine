# frozen_string_literal: true

module Validation
  def valid?
    validate!
    errors.empty?
  end

  def validate!
    raise NotImplementedError
  end

  private

  def pipe_error(error)
    @errors << error
  end

  def validate_presence_of(key)
    pipe_error(BaseInput::InputValidationError.new("#{key} is missing")) if input.send(key).blank?
  end

  def error(message)
    BaseInput::InputValidationError.new(message)
  end

  def validate_polymorphic_association!(type, id, conditional: false)
    within_error_context do
      return if conditional && id.blank?
      return pipe_error(invalid_type_error(type)) unless defined?(type.constantize)

      pipe_error(relation_not_found_error(type, id)) unless type.constantize.find_by(id:)
    end
  end

  def validate_association!(id, klass, conditional: false)
    within_error_context do
      return if conditional && id.blank?

      pipe_error(relation_not_found_error(klass.to_s, id)) unless klass.exists?(id:)
    end
  end

  def validate_record!
    within_error_context do
      validate_association!(id, self.class.target) if id
    end
  end

  def validate_required_keys!
    within_error_context do
      self.class::REQUIRED_KEYS.each do |key|
        validate_presence_of(key)
      end
    end
  end

  def validate_ownership!(record, user_id)
    within_error_context do
      pipe_error(restricted_access_error) unless owner_for(record)&.id == user_id
    end
  end

  def within_error_context(&block)
    block.call if errors.empty?
  end

  def collate_errors_for(*keys)
    keys.each do |key|
      within_error_context do
        target = send(key)
        next @errors += target.errors if target.respond_to?(:valid?) && !target.valid?

        target.each do |node|
          within_error_context do
            @errors += node.errors unless node.valid?
          end
        end
      end
    end
  end

  def invalid_type_error(type)
    BaseInput::InputValidationError.new("Invalid association type: #{type.capitalize}")
  end

  def relation_not_found_error(type, id)
    BaseInput::InputValidationError.new("Could not find any '#{type.capitalize}' with id: #{id}")
  end

  def restricted_access_error
    BaseInput::InputValidationError.new('Unauthorized access')
  end

  def missing_field_error(field)
    BaseInput::InputValidationError.new("#{field} is missing")
  end
end
