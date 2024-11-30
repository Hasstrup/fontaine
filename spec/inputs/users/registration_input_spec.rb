# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationInput do
  let(:valid_attributes) { { email: 'test@example.com', first_name: 'John', last_name: 'Doe', password: 'password' } }
  let(:invalid_attributes) { { email: '', first_name: '', last_name: '', password: '' } }

  describe '#valid?' do
    it 'returns true for valid input' do
      input = described_class.new(**valid_attributes)
      expect(input.valid?).to be_truthy
      expect(input.errors).to be_empty
    end

    it 'returns false for invalid input' do
      invalid_input = described_class.new(**invalid_attributes)
      expect(invalid_input.valid?).to be_falsey
      expect(invalid_input.errors).not_to be_empty
    end
  end

  describe '#humanized_error_messages' do
    it 'returns human-readable error messages' do
      invalid_input = described_class.new(**invalid_attributes)
      invalid_input.valid? # Trigger validation
      expect(invalid_input.humanized_error_messages).to include('email is missing')
    end
  end
end
