Rails.application.routes.draw do

  get 'password_resets/create'

  get 'password_resets/edit'

  get 'password_resets/update'

  get 'password_resets/create'

  get 'password_resets/edit'

  get 'password_resets/update'

  root 'user_sessions#new'

  resources :fines, only: [ :index ]

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
  get 'report_lost_or_damaged' => 'check_outs#report_lost_or_damaged', :as => :report_lost_or_damaged
  post 'update_lost_or_damaged' => 'check_outs#update_lost_or_damaged', :as => :update_lost_or_damaged


  resources :fines

  resources :member_fees, except: :show
  get '/member_fees/:id/waive' => 'member_fees#waive', :as => :waive

  resources :transactions, except: [:new, :create, :show]
  resources :deposits

  # User associated routes
  resources :users
  get 'users/:id/transactions' => 'transactions#user_transactions', :as => :user_transactions
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :reset_passwords, only: [:new, :create, :update, :edit]

  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

  resources :users do
    member do
      get :activate
    end
  end

  resources :charges
  get 'confirm_refund' => 'charges#confirm_refund'
  post 'refund' => 'charges#refund'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
