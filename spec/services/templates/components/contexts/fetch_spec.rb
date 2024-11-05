# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Templates::Components::Contexts::Fetch do
  let(:user) { create(:user) }
  let(:template) { create(:template, user:) }
  let!(:component1) { create(:template_component, template:) }
  let!(:component2) { create(:template_component, template:) }

  describe '.call' do
    context 'when fetching a single component' do
      it 'returns a success context with the component' do
        input = Templates::Components::QueryInput.new(fields: { id: component1.id })
        context = described_class.call(params: input, type: :single)

        expect(context).to be_success
        expect(context.payload).to eq(component1)
      end

      it 'returns a failure context when component does not exist' do
        input = Templates::Components::QueryInput.new(fields: { id: 'non_existent_id' })
        context = described_class.call(params: input, type: :single)

        expect(context).not_to be_success
        expect(context.message).to include('ActiveRecord::RecordNotFound')
      end
    end

    context 'when fetching multiple components' do
      it 'returns a success context with all components' do
        input = Templates::Components::QueryInput.new(fields: {})
        context = described_class.call(params: input)

        expect(context).to be_success
        expect(context.payload).to include(component1, component2)
      end
    end
  end
end
