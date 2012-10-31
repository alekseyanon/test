# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user, :user_logged_in?



protected

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= (current_user_session && current_user_session.record) || nil #AnonymousUser.new
  end

  # my method - without integrating Anonimous model
  def user_logged_in?
    !!current_user
  end

  def require_logged_in_user
    ActiveSupport::Deprecation.warn("#require_logged_in_user method should be replaced with CanCan") unless Rails.env == 'test'
    deny_access unless user_logged_in?
  end

  def require_anonymous_user
    ActiveSupport::Deprecation.warn("#require_anonymous_user method should be replaced with CanCan") unless Rails.env == 'test'
    return unless user_logged_in?
    flash[:error] = I18n.t(:"flash.access_denied_for_logged_in")
    ### TODO: set correct path
    #redirect_to account_path
    redirect_to root_path
  end

  def require_anonymous_or_empty_email_user
    ActiveSupport::Deprecation.warn("#require_anonymous_or_empty_email_user method should be replaced with CanCan") unless Rails.env == 'test'
    return if (!user_logged_in? || !current_user.email.present?)
    flash[:error] = I18n.t(:"flash.access_denied_for_logged_in")
    ### TODO: set correct path
    #redirect_to account_path
    redirect_to root_path
  end

  # handle redirecting
  def redirect_back_or_default(default)
    ActiveSupport::Deprecation.warn("#redirect_back_or_default pieces of omni") unless Rails.env == 'test'
    return_to = session.delete(:return_to)
    redirect_to return_to || default
  end

  # two methods for saving in session url for return
  def store_location
    ActiveSupport::Deprecation.warn("#store_location, fucking why?")
    session[:return_to] = request.url
  end
     
  def unstore_location
    ActiveSupport::Deprecation.warn("#unstore_location, fuck unfuck")
    session[:return_to] = nil
  end

  
    ### TODO: add handling of errors!
    ### TODO: add handling of errors!!
    ### TODO: add handling of errors!!!
    ### TODO: add handling of errors!!!!

end
