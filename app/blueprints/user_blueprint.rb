# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  fields(*%i[first_name last_name email])
end
