Rails.application.routes.draw do
  devise_for :users

  # Healthcheck
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root to: "activities#index"

  # Activities
  resources :activities do
    collection do
      get :my_activities
      get :trip_activities
    end
    member do
      post :favorite
      delete :unfavorite
      get :choose_trip
    end

    # ⭐ Avis (notation/commentaire) liés à une activité
    resources :reviews, only: [:index, :create, :update, :destroy]
  end

  # Trips
  resources :trips do
    resources :chats, only: [:create]
    resources :trip_activities, only: [:index, :create, :destroy]
    resources :trip_categories, only: [:create, :destroy]
    member do
      post :save_message
    end
  end

  # root "posts#index"

  resources :conversations, only: [:index, :show, :create] do
    resources :private_messages, only: :create
  end

  resources :chats, only: [:create, :show, :index] do
    resources :trips, only: [:create]
    resources :messages, only: [:create]
  end
end
