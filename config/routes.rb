Rails.application.routes.draw do

  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"
  get '/auth/github', as: 'github_login'

  resources :sessions

  resources :products

  resources :categories

  resources :carts

  resources :reviews

  resources :users

  resources :order_items
end
