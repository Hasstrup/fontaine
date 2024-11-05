# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Contexts::Registration do
  let(:valid_input) do
    Users::RegistrationInput.new(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
  end
  let(:invalid_input) { Users::RegistrationInput.new(email: '', password: 'short') }

  describe '.call' do
    context 'with valid input' do
      it 'creates a new user and returns a success context with an authentication token' do
        context = described_class.call(input: valid_input)
        expect(context).to be_success
        expect(context.payload).to be_a(Tokens::AuthenticationToken)
        expect(context.payload.owner.email).to eq('test@example.com')
      end
    end

    context 'with invalid input' do
      it 'returns a failure context' do
        context = described_class.call(input: invalid_input)
        expect(context).not_to be_success
        expect(context.message).to include('email is missing')
      end
    end
  end
end
