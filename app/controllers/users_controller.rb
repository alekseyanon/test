# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
	
  before_filter :find_by_perishable_token, :only => [:activate, :do_activate]
	before_filter :get_authentication, :only => [:new_via_oauth, :create_via_oauth]
	#authorize_resource
	respond_to :html, :js
  
  def new
    @user = User.new
    @user.roles = [params[:type].to_sym]
  end

  def sendmail
    Notifier.signup_confirmation(current_user).deliver
    redirect_to root_url
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
		  	redirect_to pendtoact_path
		  else
        @user_session = UserSession.new
		  	render :action => :profile
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
      redirect_to edit_user_path(current_user)
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
          user.activate! if user.state == 'pending_activation'
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
            user.register(activate: true)
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
      user_signed_up#(@user)
      # TODO: add my view
      render :template => 'users/registration_completed'
      #, :layout => 'registration'
    else
      render :action => :new_via_oauth
      #, :layout => 'registration'
    end
  end


  def edit
	  @user = current_user
    @authentications = @user.authentications.all
    @connected_providers = @authentications.map { |auth| auth.provider }
	end

  def settings
    @user = current_user
    @authentications = current_user.authentications.all
    @connected_providers = @authentications.map { |auth| auth.provider }

  end

  def update_settings
    @user = current_user

    if params[:user][:old_password].present?
      @user.old_password = params[:user][:old_password]
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password]
      @user.need_to_check_old_password = true
    end

    @user.news_subscribed = params[:user][:news_subscribed]
    @user.comments_subscribed = params[:user][:comments_subscribed]
    @user.answer_subscribed = params[:user][:answer_subscribed]
    @user.email = params[:user][:email] if params[:user][:email].present?
    
    if @user.save
      flash[:notice] = I18n.t("users.actions.update_password.flash")
      redirect_to current_user
    else
      @authentications = current_user.authentications.all
      @connected_providers = @authentications.map { |auth| auth.provider }
      render :settings
    end
  end

  ### TODO: delete this method
  # def update_email
  #   if @user.change_email(params[:user])
  #     current_user_session.destroy
  #     flash[:notice] = I18n.t("users.actions.email_updated")
  #     redirect_to '/'
  #   else
  #     render :action => 'change_password_or_email'
  #   end
  # end

	def update
	  @user = current_user
    # if params[:user][:crop_x].present?
    #   session[:x] = params[:user][:crop_x]
    #   session[:y] = params[:user][:crop_y]
    #   session[:w] = params[:user][:crop_w]
    #   session[:h] = params[:user][:crop_h]
    # end
	  if @user.update_attributes(params[:user])
      if params[:user][:avatar].present?
        
        render :crop
      else
  	    flash[:notice] = I18n.t("users.actions.update.flash")
  	    redirect_to current_user
      end
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

  def show
    @user = User.find(params[:id])
    @authentications = @user.authentications
  end

  def activate
  end

  def do_activate
    if @user
      unless @user.active?
        @user.activate!
      end

      # Log user in
      UserSession.create(@user)

      user_signed_up#(@user)

      ### activate something if user save it in depending_activation state
      flash[:notice] = I18n.t("users.actions.do_activate.flash")
      redirect_to root_url
    end
  end  

  def profile
    if current_user
      redirect_to current_user
    else
      @user = User.new
      @user.roles = [params[:type].to_sym]
      @user_session = UserSession.new
    end
  end
	private
	  def get_authentication
	    @authentication = Authentication.find(params[:authentication_id])
	  end

	  def user_signed_up#(user)
      ### TODO: if we need integration with google analitics
      ### we can use this methods for send data to this service
	    # user_role = 'registration.' << (user.role?(:contractor) ? 'contractor' : 'employer')
	    # ga_track_event(:users, :registration, user_role)
	    session[:just_signed_up] = true # in original it was a method, which named:
                                      # set_just_signed_up
	  end

    def find_by_perishable_token
      @user = User.find_using_perishable_token(params[:token], 3.years)
      if @user.nil?
        flash[:error] = I18n.t("users.errors.find_by_perishable_token")
        redirect_to root_url
      end
    end
end
