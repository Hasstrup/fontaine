# frozen_string_literal: true

module Templates
  class Component < ApplicationRecord
    self.table_name = 'templates_components'

    belongs_to :template, class_name: 'Templates::Template'
  end
end

# == Schema Information
#
# Table name: templates_components
#
#  id            :bigint           not null, primary key
#  key_tag       :string
#  key_type      :string
#  metadata      :jsonb
#  text_accessor :string
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  template_id   :bigint
#
# Indexes
#
#  index_templates_components_on_template_id  (template_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => templates_templates.id)
#
