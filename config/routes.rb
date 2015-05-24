Rails.application.routes.draw do
  root 'books#index'

  resources :check_outs, only: [ :index, :show, :new, :create ] do
    resources :fines, only: [ :update ]
  end

  patch 'check_outs/:id/check_in' => 'check_outs#check_in', as: :check_out_check_in
  patch 'check_outs/:id/renew' => 'check_outs#renew', as: :check_out_renew

  resources :books do
    resources :holds, only: [:new, :create]
  end
  resources :holds, only: [:index, :destroy]
  get 'myholds' => 'holds#my_holds'

  resources :check_outs
<<<<<<< HEAD
  resources :users, only: [:new, :create, :edit, :show]
=======
  resources :users, only: [:new, :create, :show, :edit, :index]
>>>>>>> 3d52b1f3943f825f6b97291f44401e8d2a98235a
  resources :user_sessions, only: [:new, :create, :destroy]

  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout


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
