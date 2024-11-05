# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Templates::Components::QueryInput do
  let(:user) { create(:user) }
  let(:template) { create(:template, user:) }
  let(:component) { create(:template_component, template:) }
  let(:valid_fields) { { email: component.email } }
  let(:invalid_fields) { { unknown_field: 'value' } }

  describe '#conditions' do
    context 'with valid fields' do
      let(:input) { described_class.new(fields: { id: component.id }) }

      it 'returns the correct conditions' do
        expect(input.conditions).to include(id: component.id)
      end
    end
  end

  describe '#includes' do
    context 'with valid includes' do
      let(:input) { described_class.new(fields: { includes: ['template'] }) }

      it 'returns the correct includes' do
        expect(input.includes).to include(:template)
      end
    end

    context 'with invalid includes' do
      let(:input) { described_class.new(fields: { includes: ['invalid_association'] }) }

      it 'returns an empty array' do
        expect(input.includes).to be_empty
      end
    end
  end

  describe '#sanitize!' do
    context 'with nil values' do
      let(:input) { described_class.new(fields: { id: nil }) }

      it 'removes nil keys' do
        input.sanitize!
        expect(input.params).not_to include(nil)
      end
    end
  end
end
