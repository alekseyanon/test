# -*- encoding : utf-8 -*-
class AuthenticationsController < ApplicationController

	### TODO: add view for this action
	def index
    @authentications = current_user ? current_user.authentications.all : []
  end

	def destroy
    # remove an authentication linked to the current user
    current_user.authentications.destroy params[:id]
    redirect_to authentications_path
  end


  ### TODO: мы считаем что пользователи могут логиниться
  ###       только под предложенными нами аккаунтами.(Facebook/twitter)
  def create
    oauth = request.env['omniauth.auth']
    unless oauth
      render text: 'No response'
      return
    end

    if oauth['provider'] && oauth['uid']
      auth = Authentication.find_by_provider_and_uid(oauth['provider'], oauth['uid'])

      if current_user
        current_user.create_authentication(oauth) unless auth
        redirect_to authentications_path
      else
        sign_in_and_redirect(:user, User.find_or_create(auth, oauth))
      end
    else
      render new_user_registration_path
    end
  end
end
