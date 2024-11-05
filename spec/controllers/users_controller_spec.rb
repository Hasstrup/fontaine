# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { create(:token, owner: user) }

  describe 'POST #register' do
    let(:valid_attributes) do
      { user: { email: 'test@example.com', first_name: 'John', last_name: 'Doe', password: 'password' } }
    end
    let(:invalid_attributes) { { user: { email: '', password: '' } } }

    context 'when the request is valid' do
      before do
        allow(::Users::Contexts::Registration).to receive(:call).and_return(double(success?: true, payload: token))
      end

      it 'returns a success response' do
        post :register, params: valid_attributes
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('token')
      end
    end

    context 'when the request is invalid' do
      before do
        allow(::Users::Contexts::Registration).to receive(:call).and_return(double(success?: false,
                                                                                   message: 'Invalid input'))
      end

      it 'returns an error response' do
        post :register, params: invalid_attributes
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['message']).to eq('Invalid input')
      end
    end
  end

  describe 'POST #authenticate' do
    let(:valid_credentials) { { user: { email: user.email, password: 'password' } } }
    let(:invalid_credentials) { { user: { email: user.email, password: 'wrong_password' } } }

    context 'when credentials are valid' do
      before do
        allow(::Users::Contexts::Authentication).to receive(:call).and_return(double(success?: true, payload: token))
      end

      it 'returns a success response' do
        post :authenticate, params: valid_credentials
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('token')
      end
    end

    context 'when credentials are invalid' do
      before do
        allow(::Users::Contexts::Authentication).to receive(:call).and_return(double(success?: false,
                                                                                     message: 'Invalid credentials'))
      end

      it 'returns an error response' do
        post :authenticate, params: invalid_credentials
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['message']).to eq('Invalid credentials')
      end
    end
  end

  describe 'GET #show' do
    context 'when the user exists' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(::Users::Contexts::Fetch).to receive(:call).and_return(double(success?: true, payload: user))
      end

      it 'returns a success response with the user data' do
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('id' => user.id)
      end
    end

    context 'when the user does not exist' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
        allow(::Users::Contexts::Fetch).to receive(:call).and_return(double(success?: false, message: 'User not found'))
      end

      it 'returns an error response' do
        get :show, params: { id: 'non_existent_id' }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['message']).to eq('User not found')
      end
    end
  end
end
