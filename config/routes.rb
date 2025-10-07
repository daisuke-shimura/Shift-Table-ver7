Rails.application.routes.draw do
  scope module: :public do
    root to: "homes#top"
  end

  devise_for :admin ,controllers: {
    sessions: "admin/sessions",
    registrations: "admin/registrations"
    
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
