Rails.application.routes.draw do

  root 'products#root', as: 'homepage'

  # OmniAuth
  get '/auth/:provider/callback', to: 'sessions#create', as: 'auth_callback'
  get '/auth/github', as: 'github_login'

  # Sessions
  delete '/login', to: 'sessions#destroy', as: 'logout'
  get '/user/:id/products', to: 'sessions#show', as: 'user_products'
  get '/user/:id', to: 'sessions#index', as: 'user_profile'

  # Cart
  get '/cart', to: 'orderproducts#index', as: 'cart'
  get 'orderproducts/clearcart', to: 'orderproducts#clear_cart', as: 'clearcart'

  # Reviews:
  resources :reviews

  # Products:
  resources :products

  resources :products do
    # add orderproducts (cart#index)
    resources :categories, only: [:index]
    resources :reviews, only: [:new,:create]
    # resources :merchants, only: [:index]
    resources :categories, only: [:index]
    resources :orderproducts
  end

  # Merchants:
  resources :merchants do
    resources :products, only: [:index]
    resources :orders, only: [:index]
  end

  # Categories:
  resources :categories

  # Orders:
  resources :orders

  # orderproducts:
  resources :orderproducts
end
