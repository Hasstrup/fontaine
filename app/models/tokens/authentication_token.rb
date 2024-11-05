# frozen_string_literal: true

class Tokens::AuthenticationToken < Tokens::Token
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
