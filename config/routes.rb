Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#root'

 # TODO changed using nested routes instead - leaving these here so you can see what we had previously
  # get '/products/:id/reviews/new', to: 'reviews#new', as: 'new_product_review'

  resources :products do
   resources :reviews, only: [:new, :create]
  end

  resources :users do
    resources :products, only: [:index]
  end

  resources :categories do
    resources :products, only: [:index]
  end

  get '/login', to: 'sessions#new', as: 'login'
  # used get for action on logout because we could not resolve an issue, per
  # instructor's suggestion
  get '/logout', to: 'sessions#logout', as: 'logout'
  get "/auth/:provider/callback", to: "sessions#create", as: 'auth_callback'

  resources :carts, only: [:show, :edit, :update]
  post '/carts', to: 'carts#add_to_cart', as: :add_to_cart
  post '/add', to: 'sessions#add_cart_product', as: :add_product

  get 'carts/:id/checkout', to: 'carts#checkout', as: :checkout
  post 'carts/:id/checkout', to: 'carts#finalize'

  get 'order/:id', to: 'carts#order_details', as: :order
  patch 'order/:id', to: 'carts#order_status'


end
