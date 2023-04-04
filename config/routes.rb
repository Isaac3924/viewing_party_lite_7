Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "welcome#index"

  get "/register", to: "users#new"
  post "/register", to: "users#create"

  get "/users/:id/discover", to: "users#discover"
  get "/users/:id/movies", to: "users#movie_results"
  get "/users/:user_id/movies/:movie_id", to: "users#movie_details"

  get "/login", to: "users#login_form"
  post "/login", to: "users#login"

  patch "/logout", to: "users#logout"

  resources :users, only: [:show] do
    resources :movies, only: [:show] do
      resources :viewing_parties, :path => "viewing_party", only: [:new, :create], controller: "viewing_parties" 
    end
  end
end
