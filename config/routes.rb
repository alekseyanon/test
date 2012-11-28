Smorodina::Application.routes.draw do
  resources :landmark_descriptions do
    collection do
      get 'search'
      post 'do_search'
    end
  end

  resources :landmarks do
    collection do
      get 'search'
      post 'do_search'
    end
  end

  # Авторизация через социальные сервисы
  resources :authentications, :only => [:edit, :update, :destroy]
  match "/user/social_accounts", :to => "authentications#index", :as => :auth_list
  match "/auth/:provider", :to => "users#auth_callback", :as => :auth
  match "/auth/:provider/callback", :to => "users#auth_callback", :as => :auth_callback

  controller :users do
    get( "/signup/:type", :action => :new, :as => :signup,
         :constraints => {:type => /traveler/} )

    get '/sendmail', :action => "sendmail"
    #TODO cleanup
    #get '/contractor_campaign', :action => 'contractor_campaign', :as => :contractor_campaign
    #get '/signup', :action => 'signup', :as => :signup_page
    get 'activate/:token', :action => 'activate', :as => :activate_user
    post 'activate/:token', :action => 'do_activate'
    
    get '/profile/:type', :action => 'profile', as: :profile, :constraints => {:type => /traveler/}
  end
  resources :users, :except => :new, :constraints => { :id => /[^\/]*\d+/ } do
    new do
      get :new_via_oauth
      post :create_via_oauth
    end

    member do
      get :settings
      put :update_settings, :reset_password
    end
  end

  controller :welcome do
    get '/activation', :action => "pend_act", :as => :pendtoact
  end

  # routing for manage user_session model with nice url
  controller :user_sessions do
    get '/login', :action => 'new', :as => :login
    post '/login', :action => 'create'
    delete '/logout', :action => 'destroy'
  end

  resources :user_sessions # TODO: check errors
  controller :reset_password do 
    get "/forget_password", :action => 'forget_password'
    post "/forget_password", :action => 'send_instruction' 
    get 'password_reset/:token', :action => 'password_form', :as => :reset_password
    post 'password_reset/:token', :action => 'update_password'
  end
  #resources :reset_password, :only => [ :new, :create, :edit, :update ]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
