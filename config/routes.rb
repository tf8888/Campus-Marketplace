Rails.application.routes.draw do
  get "home/index"
  root "home#index"

  # OAuth routes
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  # Sessions (regular login)
  get "/login", to: "sessions#login"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  resources :items do
    collection do
      get :my_listings
    end

    member do
      patch :mark_unavailable
    end
  end
end
