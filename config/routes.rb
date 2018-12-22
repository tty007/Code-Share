Rails.application.routes.draw do
  #固定ページ設定
  root to: 'home#index'
  get '/about', to: 'home#about'
  get 'contact', to: 'home#contact'
  get 'howtouse', to: 'home#howto'

  #ユーザープロフィール
  get '/profile', to: 'users#show'
  #Codeモデルに対するリソースルート生成
  resources :codes
  #Twitter用のルーティング
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end