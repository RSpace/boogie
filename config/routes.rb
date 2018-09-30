Rails.application.routes.draw do
  devise_for :users
  resources :bookings, :only => [:index, :new, :create, :show]
  namespace :admin do
    resources :bookings, :except => :show
  end

  # Static pages
  get 'pages/terms' => 'pages#terms', as: :terms
  get 'pages/reps' => 'pages#reps', as: :reps, login_required: true
  get 'pages/rules' => 'pages#rules', as: :rules
  get 'pages/cleaning' => 'pages#cleaning', as: :cleaning
  get 'pages/about' => 'pages#about', as: :about
  get 'pages/price' => 'pages#price', as: :price

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: redirect("http://turtle.boogie-103357.c66.me")

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
