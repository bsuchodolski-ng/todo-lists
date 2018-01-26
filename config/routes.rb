Rails.application.routes.draw do
  root 'to_do_lists#index'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  resources :users, only: [:new, :create, :edit, :update, :destroy]
end
