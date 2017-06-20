Rails.application.routes.draw do
  root "static_pages#home"
  get "help", to: "static_pages#help"
  get "about", to: "static_pages#about"
  get "contact", to: "static_pages#contact"
  get "sign_up", to: "users#new"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  resources :users do
    collection do
      get "password/edit", action: :edit_password
      patch "password/update", action: :update_password
    end
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit, :update]
  resources :password_resets, except: [:index, :show, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
