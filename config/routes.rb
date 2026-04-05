Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  root "home#index"

  # Product catalog
  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  # AI-powered lace finder
  resource :lace_finder, only: [:show, :create], path: "lace-finder", controller: "lace_finder"

  # Cart
  resource :cart, only: [:show] do
    resources :cart_items, only: [:create, :update, :destroy]
  end

  # Checkout & Orders
  resources :orders, only: [:index, :show, :create] do
    collection do
      get :checkout
      post :place
    end
    member do
      get :confirmation
    end
  end

  # Razorpay payment verification
  namespace :payments do
    post :verify, to: "razorpay#verify"
  end

  # User profile
  namespace :account do
    resource :profile, only: [:show, :edit, :update]
    resources :addresses, except: [:show]
    resources :orders, only: [:index, :show]
    resources :wishlists, only: [:index, :create, :destroy]
  end

  # Admin
  namespace :admin do
    root to: "dashboard#index"
    resources :products do
      resources :product_images, only: [:create, :destroy]
      member do
        patch :update_stock
      end
    end
    resources :categories
    resources :orders do
      member do
        patch :update_status
      end
    end
    resources :users, only: [:index, :show, :edit, :update]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
