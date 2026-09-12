Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :admin do
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    root "dashboard#index"
    resources :news_articles do
      member do
        patch :publish
        patch :archive
      end
    end
    resources :categories
    resources :users, only: [ :index, :edit, :update ]
    resources :comments, only: [ :index, :destroy ]
  end

  namespace :api do
    namespace :v1 do
      post "register", to: "registrations#create"
      post "login", to: "sessions#create"

      resources :news, only: [ :index, :show ] do
        resources :comments, only: [ :create ]
      end
      resources :categories, only: [ :index ]
      resources :favorites, only: [ :index, :create, :destroy ]
      get "profile", to: "profiles#show"
    end
  end

  # Defines the root path route ("/")
  root "home#index"
end
