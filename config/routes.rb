Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  root to: 'home#index'
end
