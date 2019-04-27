Rails.application.routes.draw do
  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
  resources :sessions, only: %i[create]
  resources :users, only: %i[create update] do
    get 'forgot_password', on: :collection
    get 'reset_password', on: :collection
    post 'update_password', on: :collection
    post 'send_reset_email', on: :collection
  end

  get '/profile', to: 'users#show'

  root 'users#new'
end
