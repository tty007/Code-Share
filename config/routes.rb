Rails.application.routes.draw do
  get 'users/index'
  get '/profile', to: 'users#show'
  resources :codes
  #Twitter用のルーティング
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  root to: 'home#index'
end
