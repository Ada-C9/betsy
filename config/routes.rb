Rails.application.routes.draw do
get '/auth/:provider/callback', as: 'auth_callback', to: 'sessions#create'
get '/auth/github', as: 'github_login'


  resources :orders
  resources :sessions


  resources :categories, except: [:edit, :update, :show, :destroy] do
    resources :products, only: [:index]
  end

  resources :users, only: [:index, :show] do
    resources :products, except: [:destroy]
  end

  resources :products, only: [:index, :show] do
    resources :reviews, only: [:index, :new, :create]
  end


end
