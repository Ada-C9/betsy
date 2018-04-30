Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'products#root'

  patch '/products/:id/retire', to: 'products#retire', as: 'retire'

  get '/:id/ship_order', to: 'orders#ship_order', as: 'ship_order' 

  post '/products/:id/add_review', to: 'products#create_review', as: :create_review

  get '/auth/github', as: 'github_login'

  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get "/auth/:provider/callback", to: "sessions#create", as: 'auth_callback'

  resources :products do
    resources :reviews, only: [:new, :show, :create]
  end

  resources :orders, only: [:show, :create, :update]

  get '/checkout', to: 'carts#edit', as: :checkout
  get '/order_confirmation', to: 'carts#confirmation', as: :confirmation

  # may not need all routes for order_products
  resources :order_products
  resource :cart, only: [:show, :update]

  resources :categories, only: [:new, :create, :index, :show] do
    resources :product, only: [:root]
  end

  resources :merchants, except: [:edit, :update, :destroy] do
    resources :products, only: [:index]
    resources :orders, only: [:index]
  end

end
