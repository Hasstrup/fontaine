# frozen_string_literal: true

# spec/services/users/fetch_spec.rb

require 'rails_helper'

RSpec.describe Users::Contexts::Fetch do
  let!(:user) { create(:user, email: 'test@example.com') }
  let(:valid_input) { Users::QueryInput.new(fields: { email: 'test@example.com' }) }
  let(:invalid_input) { Users::QueryInput.new(fields: { email: 'non_existent@example.com' }) }

  describe '.call' do
    context 'when fetching a single user' do
      it 'returns a success context with the user' do
        context = described_class.call(params: valid_input, type: :single)
        expect(context).to be_success
        expect(context.payload).to eq(user)
      end

      it 'returns a failure context when user does not exist' do
        context = described_class.call(params: invalid_input, type: :single)
        expect(context).not_to be_success
        expect(context.message).to include('ActiveRecord::RecordNotFound')
      end
    end

    context 'when fetching multiple users' do
      let!(:user2) { create(:user, email: 'another@example.com') }
      let(:all_users_input) { Users::QueryInput.new(fields: {}) }

      it 'returns a success context with all users' do
        context = described_class.call(params: all_users_input, type: :group)
        expect(context).to be_success
        expect(context.payload).to include(user, user2)
      end
    end
  end
end
