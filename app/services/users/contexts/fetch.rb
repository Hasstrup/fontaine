# frozen_string_literal: true

# The Fetch class is responsible for retrieving user records from the database.
# It extends the BaseService and includes the Queries::Engine module to leverage
# query execution functionality.
class Users::Contexts::Fetch < BaseService
  include Queries::Engine

  private

  # Returns the class of the model to be queried.
  #
  # @return [Class] The model class for users.
  def klass
    ::User
  end
end
