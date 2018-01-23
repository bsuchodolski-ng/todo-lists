Rails.application.routes.draw do
  root 'to_do_lists#index'
  resources :users, only: [:new, :create, :edit, :update, :destroy]
end
