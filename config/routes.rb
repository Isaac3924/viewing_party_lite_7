Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "welcome#index"

  get "/register", to: "users#new"
  post "/register", to: "users#create"

  get "/discover", to: "users#discover"
  get "/movies", to: "users#movie_results"
  get "/movies/:movie_id", to: "users#movie_details"

  get "/login", to: "users#login_form"
  post "/login", to: "users#login"

  patch "/logout", to: "users#logout"

  resources :movies, only: [:show] do
    resources :viewing_parties, :path => "viewing_party", only: [:new, :create], controller: "viewing_parties" 
  end

  get "/dashboard", to: "users#show"
  
  namespace :admin do
    resources :dashboard, only: :index
    resources :users, only: :show
  end
end
