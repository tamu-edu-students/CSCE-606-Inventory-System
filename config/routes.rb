Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "sessions" }, skip: [ :registrations ]

  devise_scope :user do
    get "signup", to: "users#new", as: "signup"
    get "users/sign_out", to: "sessions#destroy"
    post "signup", to: "users#create"
    root to: "sessions#new", as: :unauthenticated_root
  end

  get "dashboard", to: "dashboard#index", as: "dashboard"


  resources :items do
    resource :picture, only: [ :new, :create, :destroy ]  # Single picture per item
    patch :update_picture, on: :member                  # Custom route to replace a picture
  end

  resources :bins do
    resources :pictures, only: [ :new, :create, :destroy ] # Multiple pictures per bin

    collection do
      get "view", to: "bins#index", as: "view"
      get "add", to: "bins#new", as: "add"
    end
    member do
      delete "delete", to: "bins#destroy", as: "delete"
    end
  end

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
    post "update", to: "password#update",  as: "update_password"
  end
end
