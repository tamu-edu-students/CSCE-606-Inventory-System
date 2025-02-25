Rails.application.routes.draw do
  # Devise authentication routes
  devise_for :users, controllers: { sessions: "sessions" }

  # Root path
  root to: "sessions#new", as: :unauthenticated_root

  # Devise-specific custom routes (ensure no duplication)
  devise_scope :user do
    get "signup", to: "users#new", as: "signup"
    post "signup", to: "users#create"
  end
  
  # Dashboard route
  get "dashboard", to: "dashboard#index", as: "dashboard"

  # Resources for items
  resources :items

  # Bins management
  resources :bins do
    collection do
      get "view", to: "bins#index", as: "view"
      get "add", to: "bins#new", as: "add"
    end
    member do
      delete "delete", to: "bins#destroy", as: "delete"
    end
  end

  # ✅ Add routes for locations
  resources :locations

  # Bin deletion page
  get "delete-bins", to: "bins#delete_page", as: "delete_bins"

  # Log history route
  get "log-history", to: "logs#index", as: "log_history"

  # Password Reset Routes
  scope :password do
    get "forgot", to: "password#forgot", as: "forgot_password"
    get "reset_code", to: "password#reset_code", as: "reset_code"
    post "send_reset_code", to: "password#send_reset_code", as: "send_reset_code"
    post "verify_reset_code", to: "password#verify_reset_code", as: "verify_reset_code"
    get "resend_reset_code", to: "password#resend_reset_code", as: "resend_reset_code"
    get "reset", to: "password#reset", as: "new_password_reset"
    post "update", to: "password#update", as: "update_password"
  end
end
