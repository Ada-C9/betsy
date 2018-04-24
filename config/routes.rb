Rails.application.routes.draw do

  root 'homepage#index'
  get '/homepage', to:'homepage#index', as:'homepage'
  get '/auth/:provider/callback', as: 'auth_callback', to: 'sessions#create'

  get '/auth/github', as: 'github_login'

  # get '/cart', to: 'order#', as: "empty_cart"

  # Access_cart only worked as a GET method.


  get '/cart', to: 'cart#access_cart', as: "cart"

  patch '/cart/:id', to: 'cart#update'

  delete '/cart/:id/remove_single_item', to:'cart#remove_single_item', as: "remove_single_item"

  delete '/cart/delete', to:'cart#destroy', as: "cart_destroy"



  delete "/logout", to: "sessions#destroy", as: "logout"

  post '/products/:id/add_to_cart', to: 'cart#add_to_cart', as: 'add_to_cart'

  get 'orders/:id/confirmation', to: 'orders#confirmation', as: 'order_confirmation'
  put 'orders/:id/cancel', to: 'orders#cancel', as: 'order_cancel'


  resources :orders
  resources :sessions, except: [:destroy]
  resources :order_items, only: [:new, :create, :update]

  resources :categories, except: [:edit, :update, :show, :destroy] do
    resources :products, only: [:index]
  end

  resources :users, only: [:index, :show, :create] do
    resources :products, only: [:index, :new, :create]
  end

  put 'products/:id/status', to: 'products#set_status', as: 'product_set_status'
  resources :products, only: [:index, :show, :edit, :update,] do
   resources :reviews, only: [:index, :new, :create]
 end

end
