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
# PORTAL PÚBLICO / LECTORES
# ============================================================

root "home#index"

# Registro
get  "registro", to: "reader_registrations#new",    as: :reader_register
post "registro", to: "reader_registrations#create"

# Login / logout
get    "ingresar", to: "reader_sessions#new",     as: :reader_login
post   "ingresar", to: "reader_sessions#create"
delete "salir",    to: "reader_sessions#destroy", as: :reader_logout

# Perfil
get "perfil", to: "reader_profiles#show", as: :reader_profile

# Favoritos
get    "favoritos",     to: "reader_favorites#index",   as: :reader_favorites
post   "favoritos/:id", to: "reader_favorites#create",  as: :reader_favorite
delete "favoritos/:id", to: "reader_favorites#destroy"

# Noticias públicas
resources :news_articles, only: [:show] do
  resources :comments,
            only: [:create],
            controller: "reader_comments"
end
end