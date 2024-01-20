Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'fas#index'

  # Resourceful routes for fas
  resources :fas, only: [:index, :new, :create, :show] do
    collection do
      get 'export_excel'
    end
  end

  resources :fas do
    member do
      get 'export_excel'
      post 'submit_barcode_data'
      get 'barcodes'  # New route for displaying barcode data
    end
  end
  resources :fas do
  	post 'submit_barcode_data', on: :member
  end

  # Additional routes if needed
  # get "/fas", to: "fas#index"
  get "/fas/:id", to: "fas#show"
end
