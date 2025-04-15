Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "sessions" }, skip: [:registrations]
  
  devise_scope :user do
    get "signup", to: "users#new", as: "signup"
    get "users/sign_out", to: 'sessions#destroy'
    post "signup", to: "users#create"
    root to: "sessions#new", as: :unauthenticated_root
  end
  
  get "dashboard", to: "dashboard#index", as: "dashboard"

  resources :items do
    collection do
      get :log
      get 'delete-items'
      delete 'delete-selected'
      get 'suggestions'
    end
  end
  resources :bins do
    collection do
      get "view", to: "bins#index", as: "view"
      get "add", to: "bins#new", as: "add"
      get 'delete-bins'
      delete 'delete-selected'
      get 'delete_page'
      get 'suggestions'
    end
    member do
      delete "delete", to: "bins#destroy", as: "delete"
      get :share
      post 'share', to: 'bins#update_sharing', as: 'update_sharing'
    end
    resources :shared_bins, only: [:create, :destroy]
    resources :items, only: [:new, :create, :edit, :update, :destroy]
  end
  
  get "delete-bins", to: "bins#delete_page", as: "delete_bins"

  # Log history route
  get "log-history", to: "logs#index", as: "log_history"

  # ✅ Add routes for locations
  resources :locations do
    resources :bins, only: [:index]
    resources :items, only: [:index]
  end

  # ✅ Add routes for Search API
  get 'search', to: 'search#index' # API route for fetching search data

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

  resources :friendships, only: [:index, :create, :destroy]
  resources :shared_bins, only: [:create, :destroy]
  root "bins#index"
end