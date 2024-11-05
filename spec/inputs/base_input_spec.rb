# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BaseInput do
  class TestInput < BaseInput
    include Validation
    REQUIRED_KEYS = %i[age name]
    attributes(REQUIRED_KEYS)

    def validate!
      validate_required_keys!
    end
  end

  let(:valid_attributes) { { name: 'Test', age: 30 } }
  let(:invalid_attributes) { { name: nil, age: nil } }

  describe '#initialize' do
    it 'initializes with valid attributes' do
      input = TestInput.new(**valid_attributes)
      expect(input).to be_a(TestInput)
      expect(input.name).to eq('Test')
      expect(input.age).to eq(30)
    end
  end

  describe '#valid?' do
    it 'returns true for valid input' do
      input = TestInput.new(**valid_attributes)
      expect(input.valid?).to be_truthy
    end

    it 'returns false for invalid input' do
      invalid_input = TestInput.new(**invalid_attributes)
      expect(invalid_input.valid?).to be_falsey
    end
  end

  describe '#humanized_error_messages' do
    it 'returns human-readable error messages' do
      invalid_input = TestInput.new(**invalid_attributes)
      invalid_input.valid?
      expect(invalid_input.humanized_error_messages).to include('name is missing')
      expect(invalid_input.humanized_error_messages).to include('age is missing')
    end
  end

  describe '#fetch' do
    it 'fetches the value for a given key' do
      input = TestInput.new(**valid_attributes)
      expect(input.fetch(:name)).to eq('Test')
    end

    it 'raises an error for unknown keys' do
      input = TestInput.new(**valid_attributes)
      expect { input.fetch(:unknown) }.to raise_error(KeyError)
    end
  end
end
