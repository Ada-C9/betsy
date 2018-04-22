Rails.application.routes.draw do

  root 'products#index'

  # get '/order', to: 'orders#index', as: 'order'
  # post '/order', to: 'orders#create', as: 'add_to_order'

  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  get '/auth/github', as: 'github_login'
  delete '/logout', to: "users#destroy", as: "logout"


  # resources :sessions
  get '/order' , to: 'sessions#index', as: 'order'
  post '/order' , to: 'sessions#create', as: 'add_to_order'
  patch '/order' , to: 'sessions#update', as: 'update_order_item'
  delete '/order' , to: 'sessions#destroy', as: 'delete_order_item'

  resources :products

  resources :categories

  # resources :orders

  resources :users do
    resources :products, except: [:delete]
    resources :orders, only: [:index, :show]
    resources :order_items, only: [:index]
  end

end
