# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Templates::Components::Contexts::Creation do
  let(:user) { create(:user) }
  let(:template) { create(:template, user:) }
  let(:valid_input) do
    Templates::Components::CreateInput.new(
      title: 'New Component',
      key_tags: %i[td p],
      key_type: :issue_date,
      text_accessor: 'some_text',
      template_id: template.id,
      user_id: user.id
    )
  end

  let(:invalid_input) do
    Templates::Components::CreateInput.new(
      title: '',
      key_tags: %i[td p],
      key_type: '',
      text_accessor: '',
      template_id: nil,
      user_id: user.id
    )
  end

  describe '#call' do
    context 'with valid input' do
      it 'creates a new component and returns a success context' do
        context = described_class.new(input: valid_input).call
        expect(context).to be_success
        expect(context.payload).to be_a(Templates::Component)
        expect(context.payload.title).to eq('New Component')
      end
    end

    context 'with invalid input' do
      it 'does not create a new component and returns a failure context' do
        context = described_class.new(input: invalid_input).call
        expect(context).not_to be_success
      end
    end
  end
end
