Rails.application.routes.draw do

  scope module: :public do
    root to: "homes#top"
    # User routes
    resources :users, only: [:index, :show, :new, :create, :edit, :update]
    get  "login",  to: "user_sessions#new"
    post "login",  to: "user_sessions#create"
    delete "logout", to: "user_sessions#destroy"
    # Week routes
    get 'weeks/past', to: 'weeks#past'
    resources :weeks, only: [:index] do
      # Job routes
      get 'jobs/past', to: 'jobs#past'
      resources :jobs, only: [:index, :create, :edit, :update, :destroy]
    end
  end

  devise_for :admin ,controllers: {
    sessions: "admin/sessions",
    registrations: "admin/registrations"
    
  }

  namespace :admin do
    patch 'settings/toggle_visible', to: 'settings#toggle_visible'
    get 'weeks/past', to: 'weeks#past'
    resources :weeks, only: [:index, :create, :destroy] do
      get 'jobs/past', to: 'jobs#past'
      resources :jobs, only: [:index] do 
        collection do
          get :print
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
