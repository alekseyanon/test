Smorodina::Application.routes.draw do

  namespace :api do
    get 'categories/index'
    match 'events/week/:date' => 'events#week', defaults: { format: 'json' }
    get 'events/tags'
    get 'events/search'
    match 'objects/:id/nearby' => 'objects#nearby'
    match 'objects/:id' => 'objects#show'
  end

  match '/users/auth/:provider/callback', to: 'authentications#create'

  resources :ratings, only: [:create]

  resources :profiles

  devise_for :users

  # Авторизация через социальные сервисы
  resources :authentications

  resources :images do
    resources :votes, only: [:create, :destroy]
  end

  resources :reviews do
    resources :votes, only: [:create, :destroy]
    resources :complaints, only: [:new, :create, :index, :destroy]
    resources :comments do
      resources :complaints, only: [:new, :create, :index, :destroy]
      resources :votes, only: [:create, :destroy]
    end
  end

  resources :geo_objects, path: 'objects' do
    resources :reviews, only: [:new, :create, :edit, :update]
    resources :votes, only: [:create, :destroy]
    member do
      get 'history'
    end
    collection do
      get 'search'
      post 'do_search'
      get 'coordinates'
      get 'nearest_node'
      get 'count'
    end
  end

  resources :landmarks do
    collection do
      get 'search'
      post 'do_search'
    end
  end

  resources :events

  controller :welcome do
    get '/activation', action: 'pend_act', as: :pendtoact
    get '/new', action: 'new'
    get '/edit', action: 'edit'
    get '/show', action: 'show'
    get '/history', action: 'history'
    get '/post', action: 'post'
    get '/to_twitter', action: 'to_twitter'
    get '/to_facebook', action: 'to_facebook'
  end

  root to: 'welcome#home'

end
