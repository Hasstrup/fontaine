# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Contexts::Authentication do
  let(:user) { create(:user, email: 'test@example.com', password: 'password') }
  let(:valid_input) { Users::AuthenticationInput.new(email: user.email, password: 'password') }
  let(:invalid_input) { Users::AuthenticationInput.new(email: user.email, password: 'wrong_password') }

  describe '.call' do
    context 'with valid credentials' do
      it 'returns a success context with an authentication token' do
        context = described_class.call(input: valid_input)
        expect(context).to be_success
        expect(context.payload).to be_a(Tokens::AuthenticationToken)
        expect(context.payload.owner).to eq(user)
      end
    end

    context 'with invalid credentials' do
      it 'returns a failure context' do
        context = described_class.call(input: invalid_input)
        expect(context).not_to be_success
        expect(context.message).to eq('Incorrect username/password combination')
      end
    end
  end

  describe '#user' do
    context 'when user exists' do
      it 'finds the user by email' do
        auth_context = described_class.new(input: valid_input)
        expect(auth_context.send(:user)).to eq(user)
      end
    end

    context 'when user does not exist' do
      it 'saves the ActiveRecord::RecordNotFound in the errors message' do
        invalid_input = Users::AuthenticationInput.new(email: 'non_existent@example.com', password: 'password')
        ctx = described_class.new(input: invalid_input).call

        aggregate_failures do
          expect(ctx).not_to be_success
          expect(ctx.errors).to include(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
