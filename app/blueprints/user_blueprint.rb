# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  fields(*%i[id first_name last_name email])
end
