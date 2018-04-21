Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root 'mains#index'
  resources :mains, only: [:index]

  resources :categories, only: [:new, :create] do
    resources  :products, only: [:index]
  end

  resources :users do
    resources :products, only: [:index]
    resources :categories, only: [:create]
  end

  resources :orders

  resources :products 


  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"

end
