Rails.application.routes.draw do
  if Rails.env.development?
    get "/dev/login_as/:user_id", to: "development#login_as", as: :dev_login
  end

  get "profiles/show"
  get "profiles/edit"
  get "profiles/update"
  resources :requests
  get "home/index"
  root "home#index"

  # OAuth routes
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  # Sessions (regular login)
  get "/login", to: "sessions#login"
  # post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  post "message/create", to: "message#create"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  resources :items do
    member do
      patch :mark_unavailable
    end
  end

  resources :requests, only: [ :show, :new, :create ] do
    resources :messages, only: [ :create ]
    resource :rating, only: [ :new, :create ], controller: "ratings"
  end

  resources :users, only: [ :show ] do
    member do
      get :items
      get :requests
    end
  end

  resource :profile, only: [ :show, :edit, :update ] do
    patch :send_verification_code
    post :check_verification_code
  end

  resources :users, only: [ :show ] do
  end
end
