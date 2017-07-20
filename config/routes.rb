Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "sessions#new"

  resources :users, only: [:create, :show]
  resources :songs, only: [:create, :index, :new, :edit, :update]
  resources :artists

  get "songs/search", to: "songs#search", as: :search

  get "songs/:queryterm", to: "songs#query"

  get "/signup", to: "users#new", as: :signup

  get "/profile", to: "users#profile", as: :profile

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create", as: :new_session
  delete "/logout", to: "sessions#destroy", as: :logout
end
