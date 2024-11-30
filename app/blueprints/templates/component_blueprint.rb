# frozen_string_literal: true

class Templates::ComponentBlueprint < Blueprinter::Base
  fields(*%i[id title key_tags key_type text_accessor])
  association :template, blueprint: ::Templates::TemplateBlueprint
end
