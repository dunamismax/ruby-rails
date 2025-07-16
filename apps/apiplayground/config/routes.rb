Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
  
  # API routes
  namespace :api do
    # Health and monitoring
    get :health, to: 'health#check'
    get :metrics, to: 'health#metrics'
    
    namespace :text do
      post :analyze
      post :reading_time
    end
    
    namespace :random do
      get :number
      get :numbers
    end
    
    namespace :password do
      get :generate
      get :batch
      post :validate
      post :hash, to: 'password#hash_password'
      post :verify, to: 'password#verify_password'
    end
    
    namespace :keys do
      get :generate
      get :batch
    end
    
    namespace :string do
      post :slugify
      post :truncate
      post :highlight
      post :extract_emails
      post :word_frequency
      post :sanitize_html
    end
    
    namespace :date do
      post :format
      post :time_ago
      get :current
    end
  end
end
