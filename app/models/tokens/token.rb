# frozen_string_literal: true

module Tokens
  class Token < ApplicationRecord
    self.table_name = 'tokens'
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
