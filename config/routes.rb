Rails.application.routes.draw do
  # devise_for :users
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'fas#index'

  # Resourceful routes for fas
  resources :fas do
    collection do
      get 'search'
      get 'export_excel'
      post 'submit_barcode_data'
    end
    member do
      get 'barcodes'  # New route for displaying barcode data
      get 'submitted_data'
    end
  end
  resources :barcodes
  # This route will catch any undefined route and render the error page
  match "*path", to: "application#render_error", via: :all
end
