Rails.application.routes.draw do
  resources :session, only:[:new,:create,:destroy]

  resources :reviews, only: [:index,:new,:create]

  resources :orders, only: [:index,:new,:create,:show,:edit,:update]

  resources :products, except:[:destroy]

  resources :categories do
    resources :products, only: [:index], controller: 'categories/products'
  end

  resources :users do
    resources :producs, only: [:index], controller: 'merchants/products'
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
