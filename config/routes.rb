Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # ============================================================
  # BACK-OFFICE
  # ============================================================
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

  # ============================================================
  # API
  # ============================================================
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

  # ============================================================
  # ENTRADA PRINCIPAL
  # ============================================================
  root to: redirect("/admin/login")
end
