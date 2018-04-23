Rails.application.routes.draw do

  root to:'homepage#index', as:'homepage'
  get '/auth/:provider/callback', as: 'auth_callback', to: 'sessions#create'
  get '/auth/github', as: 'github_login'

  delete "/logout", to: "sessions#destroy", as: "logout"

  get 'orders/:id/confirmation', to: 'orders#confirmation', as: 'order_confirmation'
  resources :orders
  resources :sessions, except: [:destroy]
  resources :order_items, only: [:update]

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
