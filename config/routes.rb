Smorodina::Application.routes.draw do


  resources :places, only: :show

  mount RedactorRails::Engine => '/redactor_rails'

  get 'ratings/list'

  namespace :api do
    get 'ratings/list'
    get 'chronicles/show'
    get 'categories/index'
    match 'events/week/:date' => 'events#week', defaults: { format: 'json' }
    get 'events/tags'
    get 'events/search'
    get 'events/autocomplete'
    get 'agus/search'
    match 'objects/:id/nearby' => 'geo_objects#nearby', defaults: { format: 'json' }
    match 'objects/:id' => 'geo_objects#show'
    resources :geo_objects, path: 'objects' do
      resources :votes, only: [:create, :index]
      delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
      resources :runtips do
        resources :votes, only: [:create, :index]
        delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
      end
      resources :reviews do
        resources :votes, only: [:create, :index]
        delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
        resources :comments
      end
    end

    resources :events do
      resources :votes, only: [:create, :index]
      delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
      resources :reviews do
        resources :votes, only: [:create, :index]
        delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
        resources :comments
      end
    end

    resources :reviews do
      resources :votes, only: [:create, :index]
      delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
      resources :complaints, only: [:new, :create, :index, :destroy]
      resources :comments do
        resources :complaints, only: [:new, :create, :index, :destroy]
        resources :votes, only: [:create, :index]
        delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
      end
    end
  end # End API block

  match '/users/auth/:provider/callback', to: 'authentications#create'
  match 'events/search' => 'events#index'

  resources :events do
    resources :complaints, only: [:new, :create, :index, :destroy]
    resources :reviews, only: [:new, :create, :edit, :update]
    resources :votes, only: [:create]
    delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
    resources :images
    resources :videos
    resources :you_tubes, path: 'videos'
  end

  get 'my_profile/avatar' => 'profiles#my_avatar'
  resources :profiles

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :authentications

  resources :images do
    resources :complaints, only: [:new, :create, :index, :destroy]
    resources :votes, only: [:create]
    delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
    resources :comments do
      resources :complaints, only: [:new, :create, :index, :destroy]
      resources :votes, only: [:create]
      delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
    end
  end

  resources :reviews do
    resources :votes, only: [:create]
    delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
    resources :complaints, only: [:new, :create, :index, :destroy]
    resources :comments do
      resources :complaints, only: [:new, :create, :index, :destroy]
      resources :votes, only: [:create]
      delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
    end
  end

  resources :geo_objects, path: 'objects' do
    resources :runtips do
      resources :votes, only: [:create]
      delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
      resources :complaints, only: [:new, :create, :index, :destroy]
    end
    resources :complaints, only: [:new, :create, :index, :destroy]
    resources :reviews, only: [:new, :create, :edit, :update]
    resources :votes, only: [:create]
    delete 'votes' => 'votes#destroy', defaults: { format: 'json' }
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
    get '/sitemap', action: 'sitemap'
  end

  controller :feedbacks do
    post '/send_feedback', action: 'send_feedback'
  end

  root to: 'welcome#home'

end
