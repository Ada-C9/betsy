Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#index', as: 'root'

  delete '/login', to: 'sessions#destroy', as: 'logout'


  resources :users
  resources :orders
  resources :products
  resources :categories
  # resources :reviews

  get "/auth/github", as: 'github_login'
  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"

  resources :products do
    resources :reviews, only: [:new, :create]
  end

end
