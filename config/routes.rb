Rails.application.routes.draw do
  root 'books#index'
  resources :books
  resources :users, only: [:new, :create]
  resources :user_sessions, only: [:new, :create, :destroy]
end
