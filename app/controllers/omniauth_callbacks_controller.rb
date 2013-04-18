class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  #TODO facebook, VK
  ### TODO: may be, it can be deleted
  #def facebook
  #  # You need to implement the method below in your model (e.g. app/models/user.rb)
  #  #@user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
  #  @auth = Authentication.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
  #
  #  if @user #persisted?
  #    sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
  #    set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
  #  else
  #    session["devise.facebook_data"] = request.env["omniauth.auth"]
  #    redirect_to new_user_registration_url
  #  end
  #  #render text: request.env['omniauth.auth'][:info][:email]
  #end
  #
  #def all
  #  user = User.from_omniauth(request.env["omniauth.auth"])
  #  if user.persisted?
  #    flash.notice = "Signed in!"
  #    sign_in_and_redirect user
  #  else
  #    session["devise.user_attributes"] = user.attributes
  #    redirect_to new_user_registration_url
  #  end
  #  #render text: request.env['omniauth.auth'].to_yaml
  #end
  #
  #alias_method :twitter, :all

end
