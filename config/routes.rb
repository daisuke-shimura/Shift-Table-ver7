Rails.application.routes.draw do

  scope module: :public do
    # root to: "homes#top"
    get "home", to:"homes#top"
    # User routes
    resource :users, only: [:index, :new, :create, :edit, :update]
    root  to: "user_sessions#new"
    post "login"    , to: "user_sessions#create"
    delete "logout" , to: "user_sessions#destroy"
    get "mypage"    , to: "users#show"
    get "myshift"   , to: "users#myshift"
    patch "reset"   , to: "users#reset"
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
      member do
        patch :is_created
      end
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
