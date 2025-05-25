Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
    # root "articles#index"
    root "pages#home"

    get "/archive", to: "pages#archive"

    resources :teams

    resources :events

    resources :event_scores

    resources :articles do
      resources :comments
    end

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
