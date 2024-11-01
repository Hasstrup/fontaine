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
#  id              :bigint           not null, primary key
#  accessor        :string
#  instructions    :jsonb
#  metadata        :jsonb
#  pdf_coordinates :string
#  summable        :boolean          default(FALSE)
#  title           :string           not null
#  within_table    :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  template_id     :bigint
#
# Indexes
#
#  index_templates_components_on_template_id  (template_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => templates_templates.id)
#
