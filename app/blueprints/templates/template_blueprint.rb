# frozen_string_literal: true

class Templates::TemplateBlueprint < Blueprinter::Base
  fields :metadata, :rederence_file_name, :title
  association :user, blueprint: UserBlueprint
end
