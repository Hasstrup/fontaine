# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::AuthenticationInput do
  let(:valid_attributes) { { email: 'test@example.com', password: 'password' } }
  let(:invalid_attributes) { { email: '', password: '' } }

  describe '#valid?' do
    it 'returns true for valid input' do
      input = described_class.new(**valid_attributes)
      expect(input.valid?).to be_truthy
    end

    it 'returns false for invalid input' do
      invalid_input = described_class.new(**invalid_attributes)
      expect(invalid_input.valid?).to be_falsey
    end
  end

  describe '#humanized_error_messages' do
    it 'returns human-readable error messages' do
      invalid_input = described_class.new(**invalid_attributes)
      invalid_input.valid? # trigger validation
      expect(invalid_input.humanized_error_messages).to include('email is missing')
      expect(invalid_input.humanized_error_messages).to include('password is missing')
    end
  end
end
