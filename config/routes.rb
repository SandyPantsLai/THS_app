Rails.application.routes.draw do
  
  root 'user_sessions#new'
  
  resources :check_outs, only: [ :index, :show, :new, :create ] do
    resources :fines, only: [ :update ]
  end

  patch 'check_outs/:id/check_in' => 'check_outs#check_in', as: :check_out_check_in
  patch 'check_outs/:id/renew' => 'check_outs#renew', as: :check_out_renew

  
  resources :books do
    resources :holds, only: [:new, :create]
  end

  post 'books/search_google' => 'books#search_google', as: :book_search_google

  resources :holds, only: [:index, :destroy]
  get 'myholds' => 'holds#my_holds'

  resources :check_outs

  # User associated routes

  resources :users
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :reset_passwords, only: [:new, :create, :update, :edit]

  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

  resources :users do
    member do
      get :activate
    end
  end
  
end
