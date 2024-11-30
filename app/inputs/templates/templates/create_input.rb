# frozen_string_literal: true

# Input class for creating a template.
#
# This class defines the required attributes and validation rules needed to
# create a new template. The input data includes file details and the user
# who owns the template.
#
# @see BaseInput for general input structure.
class Templates::Templates::CreateInput < BaseInput
  # List of required attributes for template creation.
  REQUIRED_KEYS = %i[title file_name file_base64 user_id]

  # Attributes defined by REQUIRED_KEYS.
  attributes(*REQUIRED_KEYS)

  # Validates the input data by ensuring required keys are present and the
  # user association is valid.
  #
  # @raise [ValidationError] if required keys are missing or user validation fails.
  # @return [void]
  def validate!
    validate_required_keys!
    validate_user!
  end

  private

  # Validates the user association.
  #
  # Checks that the provided `user_id` references a valid User record.
  # This method is wrapped in an error context for easier debugging if
  # validation fails.
  #
  # @raise [ValidationError] if the user_id is not valid.
  # @return [void]
  def validate_user!
    within_error_context do
      validate_association!(user_id, User)
    end
  end
end
