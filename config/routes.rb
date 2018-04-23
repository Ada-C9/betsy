Rails.application.routes.draw do

  get '/auth/:provider/callback', as: 'auth_callback', to: 'sessions#create'

  get '/auth/github', as: 'github_login'

  get '/cart', to: 'orders#display_cart', as: "cart"

  delete "/logout", to: "sessions#destroy", as: "logout"

  post '/products/:id/add_to_cart', to: 'products#add_to_cart', as: 'add_to_cart'

  get 'orders/:id/confirmation', to: 'orders#confirmation', as: 'order_confirmation'

  resources :orders
  resources :sessions, except: [:destroy]
  resources :order_items, only: [:new, :create, :update]

  resources :categories, except: [:edit, :update, :show, :destroy] do
    resources :products, only: [:index]
  end

  resources :users, only: [:index, :show, :create] do
    resources :products, only: [:index, :new, :create]
  end

  resources :products, only: [:index, :show, :edit, :update,] do
   resources :reviews, only: [:index, :new, :create]
 end

end
