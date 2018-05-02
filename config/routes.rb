Rails.application.routes.draw do

  get '/auth/:provider/callback', to: 'merchants#login'
  get '/auth/github', as: 'github_login'

  delete "/logout", to: "merchants#destroy", as: "logout"

  root 'products#welcome'
  resources :categories, only: [:create, :index, :new] do
    resources :products, only: [:index]
  end
  resources :reviews, only: [:create, :new]
  resources :order_items #, except: [:destroy]  #at some point, we'll want to destroy this route, using it as an admin page for now
  patch 'order_items/:id/mark_shipped', to: 'order_items#mark_shipped', as: 'mark_item_shipped'
  patch 'orders/:id/checkout_order', to: 'orders#checkout_order', as: 'checkout_order'
  patch 'orders/:id/cancel_order', to: 'orders#cancel_order', as: 'mark_order_cancelled'
  resources :orders, only: [:new, :create, :edit, :update, :show, :index]
  resources :products, except: [:destroy] do
    resources :reviews, only: [:create, :new]
  end
  get '/manageinventory', to: "merchants#manage", as: 'manage_inventory'
  patch '/products/:id/deactivate', to: "products#deactivate", as: 'deactivate_product'
  get '/cart', to: "orders#cart", as: 'view_cart'
  # patch '/cart', to: "order#view_cart", as: 'view_cart'
  #resources :merchants #, only: [:create, :show, :index]
  resources :merchants do
    resources :products, only: [:index] #may be a use to adding :show
    resources :orders, only: [:show]
  end
  #Pretty sure we can delete the merchant order_items below
  # resources :merchants do
  #   resources :order_items, only: [:index]
  # end
  # resources :merchants do
  #
  # end
  get 'merchants/:id/orders', to: "merchants#order_fulfillment", as: 'merchant_orders'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
