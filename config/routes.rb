Rails.application.routes.draw do
  get 'signup', to: 'users#new'

  resources :users, only: %i[create update]
  get '/profile', to: 'users#show'

  root 'users#new'
end
