Rails.application.routes.draw do
  namespace :admin do
    resources :users
    get "login" => "auth#login"
    post "login" => "auth#create"
    get "dashboard" => "auth#dashboard"
    delete "logout" => "auth#destroy"
    get "analytics" => "analytics#index"
  end
  get "role_selection/index"
  get "roles" => "role_selection#index", as: :roles
  get "splash/index"

  # Splash screen route
  get 'splash', to: 'splash#index', as: 'splash'
  
  # Storekeeper routes
  resources :storekeeper, only: [:index, :new, :create]
  
  # Supplier routes
  resources :suppliers
  
  # Manager routes
  get 'manager/dashboard', to: 'manager#dashboard'
  get 'manager/inventory', to: 'manager#inventory'
  get 'manager/menu_management', to: 'manager#menu_management'
  
  # Menu items routes
  resources :menu_items
  
  # Customer routes
  get 'customer/login', to: 'customer#login'
  get 'customer/table_selection', to: 'customer#table_selection'
  post 'customer/select_table', to: 'customer#select_table'
  get 'customer/qr_scan/:qr_code', to: 'customer#qr_scan', as: 'customer_qr_scan'
  get 'customer/menu', to: 'customer#menu'
  post 'customer/add_to_order', to: 'customer#add_to_order'
  get 'customer/view_order', to: 'customer#view_order'
  post 'customer/place_order', to: 'customer#place_order'
  get 'customer/order_status', to: 'customer#order_status'
  get 'customer/feedback/:order_id', to: 'customer#give_feedback', as: 'customer_feedback'
  post 'customer/feedback/:order_id', to: 'customer#submit_feedback'
  get 'customer/thank_you', to: 'customer#thank_you'
  
  # Kitchen routes
  get 'kitchen/dashboard', to: 'kitchen#dashboard'
  patch 'kitchen/start_cooking/:id', to: 'kitchen#start_cooking', as: 'kitchen_start_cooking'
  patch 'kitchen/mark_ready/:id', to: 'kitchen#mark_ready', as: 'kitchen_mark_ready'
  get 'kitchen/order_details/:id', to: 'kitchen#order_details', as: 'kitchen_order_details'
  
  # Cashier routes
  get 'cashier/dashboard', to: 'cashier#dashboard'
  get 'cashier/generate_bill/:id', to: 'cashier#generate_bill', as: 'cashier_generate_bill'
  post 'cashier/print_bill/:id', to: 'cashier#print_bill', as: 'cashier_print_bill'
  get 'cashier/bill_details/:id', to: 'cashier#bill_details', as: 'cashier_bill_details'
  
  # Direct order routes
  resources :orders, only: [:new, :create] do
    member do
      get :confirmation
    end
  end
  
  # Set root path to splash screen
  root 'splash#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

end