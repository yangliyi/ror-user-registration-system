Rails.application.routes.draw do
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
  resources :sessions, only: %i[create]
  resources :users, only: %i[create update]
  get '/profile', to: 'users#show'

  root 'users#new'
end
