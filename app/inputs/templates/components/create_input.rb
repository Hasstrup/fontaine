# frozen_string_literal: true

# The CreateInput class is responsible for validating the input required
# to create a new template component. It checks for the presence of necessary
# attributes and ensures that the template and user associations are valid.
class Templates::Components::CreateInput < BaseInput
  # The required keys for the input attributes.
  REQUIRED_KEYS = %i[key_tags key_type text_accessor template_id user_id]

  attributes(:title, *REQUIRED_KEYS)

  # Validates the input attributes for creating a component.
  #
  # @raise [BaseInput::InvalidInputError] If required keys are missing or associations are invalid.
  def validate!
    validate_required_keys!
    validate_template!
    validate_user!
  end

  private

  # Validates the presence and association of the template.
  #
  # @raise [BaseInput::InvalidInputError] If the template association is invalid.
  def validate_template!
    within_error_context do
      validate_association!(template_id, ::Templates::Template)
    end
  end

  # Validates the presence and association of the user.
  #
  # @raise [BaseInput::InvalidInputError] If the user association is invalid.
  def validate_user!
    within_error_context do
      validate_association!(user_id, ::User)
      validate_template_ownership!
    end
  end

  # Checks if the user has ownership of the specified template.
  #
  # @raise [BaseInput::InvalidInputError] If the user does not own the template.
  def validate_template_ownership!
    within_error_context do
      pipe_error(restricted_access_error) unless user_template_exists?
    end
  end

  # Checks if a template exists that belongs to the user.
  #
  # @return [Boolean] True if the template belongs to the user; otherwise, false.
  def user_template_exists?
    ::Templates::Template.exists?(user_id:, id: template_id)
  end
end
