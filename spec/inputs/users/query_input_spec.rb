# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::QueryInput do
  let(:valid_fields) { { email: 'test@example.com', first_name: 'John' } }
  let(:invalid_fields) { { unknown_field: 'value' } }

  describe '#initialize' do
    it 'initializes with valid fields' do
      input = described_class.new(fields: valid_fields)
      expect(input.params).to eq(valid_fields)
    end

    it 'handles unknown fields gracefully' do
      input = described_class.new(fields: invalid_fields)
      expect(input.params).to eq(invalid_fields)
    end
  end

  describe '#conditions' do
    context 'with valid fields' do
      let(:input) { described_class.new(fields: valid_fields) }

      it 'returns the correct conditions' do
        expect(input.conditions).to include(email: 'test@example.com')
      end
    end
  end

  describe '#includes' do
    context 'with invalid includes' do
      let(:input) { described_class.new(fields: { includes: ['invalid_association'] }) }

      it 'returns an empty array' do
        expect(input.includes).to be_empty
      end
    end
  end

  describe '#sanitize!' do
    context 'with nil values' do
      let(:input) { described_class.new(fields: { email: nil }) }

      it 'removes nil keys' do
        input.sanitize!
        expect(input.params).not_to include(nil)
      end
    end
  end
end
