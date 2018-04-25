Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :products, only: [:index, :show]

  resources :merchants do
    resources :products, only: [ :new, :create, :edit, :update]
  end

  patch "/products/retire/:id", to: "products#retire", as: "retire"
  get "/merchants/:merchant_id/display-products", to: "merchants#display", as: "display"
  resources :products, only: [:index, :edit, :show, :new, :create, :update]
  resources :products, only: [:index, :show]

  resources :merchants do
    resources :categories, only: [:index, :new, :create, :show]
  end

  resources :orders


  resources :categories, only: [:index, :edit, :show]
  resources :carts, only: [:show]
  resources :cartitems
  resources :reviews, only: [:new, :create]

  root 'products#homepage'

  get "/auth/:provider/callback", to: "sessions#login", as: "auth_callback"

  delete "/logout", to: "sessions#logout", as: "logout"

  patch "/carts/:id/empty_cart", to: "carts#empty_cart", as: "empty_cart"
end
