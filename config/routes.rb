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

<<<<<<< HEAD
  resources :products, only: [:index, :show] do
    resources :reviews, only: [:index, :new, :create]
  end
=======
  resources :products, only: [:index, :show, :edit, :update,] do
   resources :reviews, only: [:index, :new, :create]
 end
>>>>>>> acdb61965626427183367b86d2d1384c4872449f


end
