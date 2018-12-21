Rails.application.routes.draw do
  root to: 'home#index'
  get '/about', to: 'home#about'
  get 'contact', to: 'home#contact'
  get 'howtouse', to: 'home#howto'
  get '/profile', to: 'users#show'
  resources :codes
  #Twitter用のルーティング
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  
end
