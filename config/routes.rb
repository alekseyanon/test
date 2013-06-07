Smorodina::Application.routes.draw do

  get 'ratings/list'

  namespace :api do
    get 'chronicles/show'
    get 'categories/index'
    match 'events/week/:date' => 'events#week', defaults: { format: 'json' }
    get 'events/tags'
    get 'events/search'
    get 'agus/search'
    match 'objects/:id/nearby' => 'objects#nearby'
    match 'objects/:id' => 'objects#show'
    resources :objects do
      resources :runtips
      resources :reviews do
        resources :comments
      end
    end
  end

  match '/users/auth/:provider/callback', to: 'authentications#create'
  match 'events/search' => 'events#index'

  resources :events do
    resources :images
    resources :videos
    resources :you_tubes, path: 'videos'
  end

  resources :profiles

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :authentications

  resources :images do
    resources :complaints, only: [:new, :create, :index, :destroy]
    resources :votes, only: [:create, :destroy]
    resources :comments do
      resources :complaints, only: [:new, :create, :index, :destroy]
      resources :votes, only: [:create, :destroy]
    end
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
    resources :runtips do
      resources :votes, only: [:create, :destroy]
    end
    resources :reviews, only: [:new, :create, :edit, :update]
    resources :votes, only: [:create, :destroy]
    resources :images
    resources :videos
    resources :you_tubes, path: 'videos'
    member do
      get 'history'
    end
    collection do
      get 'my_location'
      get 'search'
      post 'do_search'
      get 'coordinates'
      get 'nearest_node'
      get 'count'
    end
  end

  controller :welcome do
    get '/activation', action: 'pend_act', as: :pendtoact
    get '/new', action: 'new'
    get '/edit', action: 'edit'
    get '/show', action: 'show'
    get '/history', action: 'history'
    get '/post', action: 'post'
    get '/to_social_network', action: 'to_social_network'
    get '/about', action: 'about'
    #TODO: Terms Of Service page
    get '/terms', action: 'terms'
  end

  controller :feedbacks do
    post '/send_feedback', action: 'send_feedback'
  end

  root to: 'welcome#home'

end
