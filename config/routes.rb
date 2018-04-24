Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'products#homepage'
  get "/auth/:provider/callback", to: "sessions#login", as: "auth_callback"

  delete "/logout", to: "sessions#logout", as: "logout"

  resources :products, only: [:index, :show]


  resources :products, only: [:index, :show]

  resources :merchants do
    resources :products, only: [:index, :new]
  end

  resources :merchants do
    resources :orders, only: [:index, :show]
  end

  resources :orders
  resources :categories, only: [:index, :show]
  resources :carts
  resources :cartitems
  resources :reviews


end
