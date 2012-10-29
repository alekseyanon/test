# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
	
	before_filter :get_authentication, :only => [:new_via_oauth, :create_via_oauth]
	#authorize_resource
	respond_to :html, :js
  
  def new
    @user = User.new
    @user.roles = [params[:type].to_sym]
    # logger.debug "****************roles*********************"
    # logger.debug params[:type]
  end

  def create
	  
	  providers = %w(facebook twitter vkontakte)

    # Нажата кнопка "Зарегистрироваться через..."
    provider = (params.keys & providers).first

    if provider.present?
      query = {
        :type => params[:type]
      }.to_query
      redirect_to "/auth/#{provider}?#{query}"
    else
		  @user = User.new_user(params[:type], params[:user])
		  if @user.register
         # TODO: redirect to correct page
		  	redirect_to root_url
		  else
		  	render :action => :new
		  end

		end
	end

	# Вызывается при авторизации через социальные сервисы.
  def auth_callback
    # Костыль. Нужна корректная обработка всех видов возникаемых ошибок.
    redirect_to auth_list_path, alert: params[:message] and return if "failure" == params[:provider]
    #render :text => request.env["omniauth.auth"].to_yaml

    ### debug for request from sicial networks
      # logger.debug "===============auth callback: start request=================="
      # logger.debug request
      # logger.debug request.env["omniauth"]
      # logger.debug request.env["omniauth.auth"]
      # logger.debug request.env['omniauth.params']
      # logger.debug "===============auth callback: end request=================="
    
    auth_params = request.env['omniauth.auth']
    request_params = request.env['omniauth.params']

    authentication = Authentication.find_or_create_from_provider(auth_params, request_params)

    # Если пользователь уже зашел на сайт - значит, мы привязали к нему новый социальный
    # аккаунт, редиректим на список аккаунтов
    if user_logged_in?
      authentication.update_attribute(:user, current_user)
      redirect_to auth_list_url
    elsif authentication.user.present?
    # Если ранее заходил на сайт под этим социальным аккаунтом - авторизуем его
      UserSession.create(authentication.user)
      redirect_to session[:return_to] || root_url
    else
      # Если пользователь пришел из провайдера с email'ом
      if authentication.email.present?
        # Пытаемся его найти по email'у и авторизовать.
        user = User.find_by_email(authentication.email)
        if user.present?
          authentication.update_attribute(:user, user)
          # TODO: uncomment for user states 
          # user.activate! if user.state == 'pending_activation'
          UserSession.create(user)
          redirect_to session[:return_to] || root_url
        else
          # А если не нашли - регистрируем и активируем.
          user = authentication.new_user
          if user.roles.empty?
            # TODO: Dima: Отрефакторить, я думаю что эта ветка IF'а нам не понадобится
            # Это на случай если "Зарегистрироваться через" была нажата не на форме регистрации, а сверху
            redirect_to signup_path(:type => 'traveler')
          else
            user.register
            user_signed_up(user)
            UserSession.create(user)
            
            #flash[:notice] = I18n.t("users.actions.activate")

            redirect_to root_url #invite_by_import_path
          end
        end
      else
        # Не слишком красиво: кроме роли может быть какой-то еще обязательный параметр
        if authentication.role.blank?
          redirect_to signup_path(:type => 'traveler')
        else
          # Просим пользователя ввести e-mail
          redirect_to new_via_oauth_new_user_path(:authentication_id => authentication)
        end
      end
    end
  end

  #TODO: add view for this action
  def new_via_oauth
    @user = @authentication.new_user(params[:user])
    render :layout => false
  end

  def create_via_oauth
    @user = @authentication.new_user(params[:user])
    @user.email = params[:user][:email]

    if @user.register
      user_signed_up(@user)
      # TODO: add my view
      render :template => 'users/registration_completed', :layout => 'registration'
    else
      render :action => :new_via_oauth#, :layout => 'registration'
    end
  end


  def edit
	  @user = current_user
	end

	def update
	  @user = current_user
	  if @user.update_attributes(params[:user])
	    flash[:notice] = "Вот теперь все прекрасно)"
	    redirect_to root_url
	  else
	    render :action => 'edit'
	  end
	end

  def destroy_confirmation
  end

	def destroy
    @user.reset_perishable_token!
    @user.reload
    current_user_session.destroy
    render nothing: true and return
  end

  ### TODO: write new method with useful logic
  def index
    @users=User.all
  end
	private
	  def get_authentication
	    @authentication = Authentication.find(params[:authentication_id])
	  end

	  def user_signed_up(user)
      ### TODO: if we need integration with google analitics
      ### we can use this methods for send data to this service
	    # user_role = 'registration.' << (user.role?(:contractor) ? 'contractor' : 'employer')
	    # ga_track_event(:users, :registration, user_role)
	    session[:just_signed_up] = true # in original it was a method, which named:
                                      # set_just_signed_up
	  end
end
