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
  resources :to_do_lists, only: [:index, :new, :create, :show, :update, :destroy] do
    resources :to_do_list_items, only: [:create, :update, :destroy], shallow: true
  end
  patch 'to_do_list_items/:id/done', to: 'to_do_list_items#done', as: :to_do_list_item_done

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get '/token', to: 'sessions#create'
      delete '/token', to: 'sessions#destroy'
      resources :users, only: [:show, :update, :destroy]
      resources :to_do_lists, only: [:index, :show, :create, :update]
    end
  end

end
