Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/destroy'
  #固定ページ設定
  root to: 'home#index'
  get '/about', to: 'home#about'
  get 'contact', to: 'home#contact'
  get 'howtouse', to: 'home#howto'
  get '/support', to: 'home#support'

  #ユーザープロフィール
  get '/profile', to: 'users#show'
  #Codeモデルに対するリソースルート生成
  resources :codes do
    resources :likes, only: [:create, :destroy]
  end
  #Twitter用のルーティング
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end