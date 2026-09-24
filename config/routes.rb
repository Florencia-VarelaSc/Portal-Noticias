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

    # Página principal
  root "home#index"

  
# Noticias públicas y comentarios de lectores
resources :news_articles, only: [:show] do
  resources :reader_comments,
            only: [:create],
            path: "comentarios"
end

  # Registro de lectores
  get "registro", to: "reader_registrations#new",
      as: :reader_register

  post "registro", to: "reader_registrations#create"

  # Inicio y cierre de sesión de lectores
  get "ingresar", to: "reader_sessions#new",
      as: :reader_login

  post "ingresar", to: "reader_sessions#create"

  delete "salir", to: "reader_sessions#destroy",
      as: :reader_logout

  # Perfil del lector
  get "mi-perfil", to: "reader_profiles#show",
    as: :reader_profile
  
# Favoritos del lector
get "mis-favoritos",
    to: "reader_favorites#index",
    as: :reader_favorites

post "mis-favoritos",
     to: "reader_favorites#create"

delete "mis-favoritos/:id",
       to: "reader_favorites#destroy",
       as: :reader_favorite

end