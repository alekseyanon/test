Smorodina::Application.routes.draw do

  resources :ratings, only: [:create]

  resources :profiles

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :images do
    resources :votes, only: [:create, :destroy]
  end

  resources :reviews do
    resources :votes, only: [:create, :destroy]
    resources :comments do
      resources :votes, only: [:create, :destroy]
    end
  end

  resources :landmark_descriptions do
    resources :reviews, only: [:new, :create, :edit, :update]
    member do
      get 'history'
    end
    collection do
      get 'search'
      post 'do_search'
      get 'coordinates'
      get 'nearest_node'
    end
  end

  resources :landmarks do
    collection do
      get 'search'
      post 'do_search'
    end
  end

  resources :events do
    collection do
      get 'search'
      post 'search'
    end
  end

  # Авторизация через социальные сервисы
  resources :authentications, only: [:edit, :update, :destroy]
  #match "/user/social_accounts", :to => "authentications#index", :as => :auth_list
  match "/auth/:provider", to: 'users#auth_callback', as: :auth
  match "/auth/:provider/callback", to: 'users#auth_callback', as: :auth_callback

  # controller :users do
  #   get( "/signup/:type", :action => :new, :as => :signup,
  #        :constraints => {:type => /traveler/} )

  #   get '/sendmail', :action => "sendmail"
  #   #TODO cleanup
  #   #get '/contractor_campaign', :action => 'contractor_campaign', :as => :contractor_campaign
  #   #get '/signup', :action => 'signup', :as => :signup_page
  #   get 'activate/:token', :action => 'activate', :as => :activate_user
  #   post 'activate/:token', :action => 'do_activate'

  #   get '/profile/:type', :action => 'profile', as: :profile, :constraints => {:type => /traveler/}
  # end
  # resources :users, :except => :new do
  #   new do
  #     get :new_via_oauth
  #     post :create_via_oauth
  #   end

  #   member do
  #     get :settings
  #     put :update_settings, :reset_password
  #   end
  # end

  controller :welcome do
    get '/activation', action: 'pend_act', as: :pendtoact
    get '/new', action: 'new'
    get '/edit', action: 'edit'
    get '/show', action: 'show'
    get '/history', action: 'history'
  end

  # routing for manage user_session model with nice url
  # controller :user_sessions do
  #   get '/login', :action => 'new', :as => :login
  #   post '/login', :action => 'create'
  #   delete '/logout', :action => 'destroy'
  # end

  # resources :user_sessions # TODO: check errors
  controller :reset_password do
    get '/forget_password', action: 'forget_password'
    post '/forget_password', action: 'send_instruction'
    get 'password_reset/:token', action: 'password_form', as: :reset_password
    post 'password_reset/:token', action: 'update_password'
  end

  root to: 'welcome#home'

end
