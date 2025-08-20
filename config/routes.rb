Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")

  root to: "activities#index"

  resources :activities
  resources :trips do
    resources :trip_activities
  end
  
  # root "posts#index"*

  resources :chats, only: [:create, :show, :index] do
     resources :messages, only: [:create]
  end
end
