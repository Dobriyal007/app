Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'fas#index'

  # Resourceful routes for fas
  resources :fas do
    collection do
      get 'export_excel'
      post 'submit_barcode_data'
    end
    # post 'submit_barcode_data_fa', to: 'your_controller#your_action', as: 'submit_barcode_data_fa'
    member do
      get 'export_excel'
      get 'barcodes'  # New route for displaying barcode data
      post 'submit_barcode_data'
      # get 'export_barcodes_excel'
    end
    # resources :barcodes, only: [:new, :create]
  end
  # This route will catch any undefined route and render the error page
  match "*path", to: "application#render_error", via: :all

  # Additional routes if needed
  # get "/fas", to: "fas#index"
  # get "/fas/:id", to: "fas#show"
end
