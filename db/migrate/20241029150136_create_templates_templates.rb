# frozen_string_literal: true

class CreateTemplatesTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :templates_templates do |t|
      t.string :title, null: false
      t.references :user
      t.jsonb :instructions
      t.string :reference_file_path
      t.string :reference_file_name
      t.string :type
      t.jsonb :metadata

      t.timestamps
    end
  end
end
