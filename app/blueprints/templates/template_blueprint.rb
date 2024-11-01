# frozen_string_literal: true

module Templates
  class TemplateBlueprint < Blueprinter::Base
    fields :metadata, :rederence_file_name, :title
    association :user, blueprint: UserBlueprint
  end
end
