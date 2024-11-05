# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Templates::ComponentsController, type: :controller do
  let(:user) { create(:user) }
  let(:token) do
    create(:token, owner: user,
                   token: Encryption::TokenManager.payload_2_token(data: { id: user.id }))
  end

  let(:valid_attributes) do
    {
      component: {
        title: 'Component Title',
        key_type: 'issue_date',
        text_accessor: 'some_text',
        template_id: create(:template, user:).id,
        key_tags: [:p]
      }
    }
  end

  let(:invalid_attributes) do
    {
      component: {
        title: '',
        key_type: 'some_text',
        text_accessor: '',
        template_id: nil,
        key_tags: []
      }
    }
  end

  before do
    request.headers['Authorization'] = "Bearer #{token.token}"
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new component' do
        expect do
          post :create, params: valid_attributes
        end.to change(Templates::Component, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('title' => 'Component Title')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new component' do
        expect do
          post :create, params: invalid_attributes
        end.to change(Templates::Component, :count).by(0)

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['message']).to include('key_tags is missing')
      end
    end
  end

  describe 'GET #show' do
    let!(:component) do
      create(:template_component, template: create(:template, user:))
    end

    it 'returns the requested component' do
      get :show, params: { id: component.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('id' => component.id)
    end

    it 'returns an error if the component does not exist' do
      get :show, params: { id: 'non_existent_id' }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['message']).to eq('ActiveRecord::RecordNotFound')
    end
  end

  describe 'GET #index' do
    let!(:component1) { create(:template_component, template: create(:template, user:)) }
    let!(:component2) { create(:template_component, template: create(:template, user:)) }

    it 'returns a list of components' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end
end
