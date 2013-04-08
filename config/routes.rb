Smorodina::Application.routes.draw do

  namespace :api do
    get 'categories/index'
    match 'events/week/:date' => 'events#week', defaults: { format: 'json' }
    get 'events/tags'
    get 'events/search'
  end

  resources :ratings, only: [:create]

  resources :profiles

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  # Авторизация через социальные сервисы
  resources :authentications
  #match "/user/social_accounts", :to => "authentications#index", :as => :auth_list
  #match "/auth/:provider", to: 'users#auth_callback', as: :auth
  #match "/auth/:provider/callback", to: 'users#auth_callback', as: :auth_callback
  #match "/auth/:provider", to: 'authentications#create', as: :auth
  #match "/users/auth/:provider/callback", to: 'authentications#create'
  match "/users/auth/facebook/callback", to: 'authentications#create'

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

  resources :landmark_descriptions do
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
  end

  root to: 'welcome#home'

end
