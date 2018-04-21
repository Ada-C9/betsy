Rails.application.routes.draw do



get '/auth/:provider/callback', as: 'auth_callback', to: 'sessions#create'
get '/auth/github', as: 'github_login'


  resources :orders
  resources :sessions


  resources :categories, except: [:edit, :update, :show, :destroy] do
    resources :products, only: [:index]
  end

  resources :users, only: [:index, :show] do
    resources :products, only: [:index, :new, :create]
  end

  resources :products, only: [:index, :show, :edit, :update,] do
    resources :reviews, only: [:index, :new, :create]
  end






  # resources :session, only:[:new,:create,:destroy]







  # resources :products, except:[:destroy]

  # resources :categories do
  #   resources :products, only: [:index], controller: 'categories/products'
  # end
  #
  # resources :users do
  #   resources :producs, only: [:index], controller: 'merchants/products'
  # end



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
