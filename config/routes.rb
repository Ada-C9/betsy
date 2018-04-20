Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'reviews#index', as: 'root'

  get 'login', to: 'sessions#new', as: 'login_form'
  post '/login', to: 'sessions#create', as: 'login'
  delete '/login', to: 'sessions#destroy', as: 'logout'


  resources :users
  resources :orders
  resources :products
  resources :categories
  resources :reviews

  get "/auth/github", as: 'github_login'
  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"

end
