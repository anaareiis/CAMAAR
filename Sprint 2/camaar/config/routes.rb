Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'dashboard', to: 'dashboard#index', as: :dashboard
  post 'import_data', to: 'import_data#import', as: :import_data

  namespace :admin do
    resources :users, only: [] do
      collection do
        post :import
      end
    end
    resources :turmas, only: [:index]
  end

  # Defines the root path route ("/")
  devise_scope :user do
    root "users/sessions#new"
  end
end
