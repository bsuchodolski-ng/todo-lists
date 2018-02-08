Rails.application.routes.draw do
  root 'to_do_lists#index'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/account', to: 'users#edit'
  patch '/account', to: 'users#update'
  delete '/account', to: 'users#destroy'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :to_do_lists
end
