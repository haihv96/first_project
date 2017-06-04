Rails.application.routes.draw do
  root "static_pages#home"
  get "help", to: "static_pages#help"
  get "about", to: "static_pages#about"
  get "contact", to: "static_pages#contact"
  get "signup", to: "users#signup"
  post "signup", to: "users#signup_create"
  get "signup/verify", to: "account_activations#notice_after_signup"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "profile", to: "users#profile"
  resources :users do
    member do
      get "followings", "followers"
    end
  end
  resources :account_activations, only: :edit
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
