# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show] do
    collection do
      post :register
      post :authenticate
    end
  end

  namespace :templates do
    resources :components, only: %i[index show create]
    resources :templates, only: %i(create show) do
      collection do
        post :dispatch_mail
      end
    end
  end
end
