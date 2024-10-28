# frozen_string_literal: true

class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens do |t|
      t.string :token
      t.string :type
      t.string :owner_type
      t.integer :owner_id

      t.timestamps
    end
  end
end
