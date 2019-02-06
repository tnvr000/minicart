Rails.application.routes.draw do

  get 'users/index'
  get 'users/show'
  get 'users/update'
  
  root to: 'standard_pages#index'

  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'users/registrations'}
  resources :users, only: [:index, :show, :update]
  
  resources :addresses, except: :show do
    member do
      patch 'make_default'
    end
  end
  
  resources :categories, only: :show
  
  resources :products do
    resources :images, shallow: true do
      member do
        put 'make_thumb'
      end
    end
    collection do
      get 'shopify'
      get 'products_tables', as: "table_of"
      get 'newWI'
      post 'createWI'
    end
  end
  
  resources :cart_items, only: [:index, :create, :destroy] do 
    member do
      put 'change_quantity/:dir', to: "cart_items#change_quantity", as: 'change_quantity'
    end
  end
  resources :orders

  get 'webhooks/install', to: "webhooks#install"
  get 'webhooks/auth', to: 'webhooks#auth'
  post 'webhooks/shipping_rates', to: 'webhooks#shipping_rates'
  post 'webhooks/order_created', to: 'webhooks#order_created'
  post 'webhooks/app_uninstalled', to: 'webhooks#app_uninstalled'
  # resources :images

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
