Rails.application.routes.draw do
  root 'to_do_lists#index'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users, only: [:new, :create, :edit, :update, :destroy]
end
