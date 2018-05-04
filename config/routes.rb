Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#index', as: 'root'


  resources :users
  resources :orders, only: [:index, :show, :update, :new]
  resources :categories, only: [:index, :new, :create, :show]
  resources :order_items, only: [:create, :update, :destroy]
  resources :products, only: [:show, :index]

  resources :users do
    resources :products, only: [:new, :create, :edit, :update]
  end

  post "/product/:product_id/reviews", to: "reviews#create", as: "product_reviews"
  get "/products/:product_id/reviews/new", to: "reviews#new", as: "new_product_review"

  get "/auth/github", as: 'github_login'
  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"
  delete '/logout', to: 'sessions#destroy', as: 'logout'
end
