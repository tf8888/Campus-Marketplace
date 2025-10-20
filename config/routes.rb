Rails.application.routes.draw do
  get "home/index"
  root "home#index"

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  get "/login", to: "sessions#login"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
