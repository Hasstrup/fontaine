# frozen_string_literal: true

module Templates
  class Invoice < ::Templates::Template
  end
end

# == Schema Information
#
# Table name: templates_templates
#
#  id                  :bigint           not null, primary key
#  html_content        :text
#  instructions        :jsonb
#  metadata            :jsonb
#  reference_file_name :string
#  reference_file_path :string
#  title               :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint
#
# Indexes
#
#  index_templates_templates_on_user_id  (user_id)
#
