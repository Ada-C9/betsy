Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#index', as: 'root'

  delete '/login', to: 'sessions#destroy', as: 'logout'


  resources :users
  resources :orders
  resources :categories
  resources :order_items


  get "/auth/github", as: 'github_login'
  get "/auth/:provider/callback", to: "sessions#create", as: "auth_callback"

  resources :users do
    resources :products, only: [:new, :create, :edit, :update]
  end

  get "/product/:id", to: "products#show", as: "product"
  get "/products", to: "products#index"


  post "/product/:product_id/reviews", to: "reviews#create", as: "product_reviews"
  get "/products/:product_id/reviews/new", to: "reviews#new", as: "new_product_review"
end
