# frozen_string_literal: true

class Tokens::Token < ApplicationRecord
  self.table_name = 'tokens'

  belongs_to :owner, polymorphic: true

  def blueprint
    ::Tokens::TokenBlueprint
  end
end

# == Schema Information
#
# Table name: tokens
#
#  id         :bigint           not null, primary key
#  owner_type :string
#  token      :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer
#
