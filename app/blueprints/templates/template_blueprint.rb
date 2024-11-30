# frozen_string_literal: true

class Templates::TemplateBlueprint < Blueprinter::Base
  fields(*%i[id metadata reference_file_name title html_content])
  association :user, blueprint: UserBlueprint
end
