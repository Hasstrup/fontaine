# frozen_string_literal: true

class CreateTemplatesComponents < ActiveRecord::Migration[6.1]
  def change
    create_table :templates_components do |t|
      t.string :title, null: false
      t.string :key_tag
      t.string :key_type
      t.string :text_accessor
      t.references :template, foreign_key: { to_table: :templates_templates }
      t.jsonb :metadata

      t.timestamps
    end
  end
end
