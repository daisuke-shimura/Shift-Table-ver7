Rails.application.routes.draw do

  scope module: :public do
    root to: "homes#top"
    # User routes
    resources :users, only: [:index, :show, :new, :create, :edit, :update]
    get  "login",  to: "user_sessions#new"
    post "login",  to: "user_sessions#create"
    delete "logout", to: "user_sessions#destroy"
    # Week routes
    resources :weeks, only: [:index, :create, :destroy] do
      # Job routes
      resources :jobs, only: [:index, :create, :update, :destroy]
    end
  end

  devise_for :admin ,controllers: {
    sessions: "admin/sessions",
    registrations: "admin/registrations"
    
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
