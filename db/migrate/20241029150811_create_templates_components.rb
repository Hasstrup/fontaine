# frozen_string_literal: true

class CreateTemplatesComponents < ActiveRecord::Migration[6.1]
  def change
    create_table :templates_components do |t|
      t.string :title, null: false
      t.string :accessor
      t.references :template, foreign_key: { to_table: :templates_templates }
      t.boolean :summable, default: false
      t.string :pdf_coordinates
      t.boolean :within_table, default: false
      t.jsonb :metadata
      t.jsonb :instructions

      t.timestamps
    end
  end
end
