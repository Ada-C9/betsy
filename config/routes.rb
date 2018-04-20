Rails.application.routes.draw do


  resources :categories, except: [:edit, :update, :show, :destroy] do
    resources :products, only: [:index]
  end

  resources :users, only: [:index, :show] do
    resources :products, except: [:destroy]
  end

  resources :products, only: [:index, :show, :update]




  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
