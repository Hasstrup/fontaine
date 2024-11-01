# frozen_string_literal: true

module Templates
  class ComponentBlueprint < Blueprinter::Base
    fields(*%i[title key_tag key_type text_accessor])
    association :template, blueprint: ::Templates::TemplateBlueprint
    association :user, blueprint: UserBlueprint
  end
end
