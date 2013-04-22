# -*- encoding : utf-8 -*-
class AuthenticationsController < ApplicationController

	### TODO: add view for this action
	def index
    @authentications = current_user ? current_user.authentications.all : []
    #@connected_providers = @authentications.map { |auth| auth.provider }
  end

	def destroy
    # remove an authentication linked to the current user
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy

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
    provider = oauth['provider']
    uid = oauth['uid']
    email = (provider == 'facebook' ? oauth['info']['email'] : nil)

    oauth_token = get_auth_token(provider, oauth)
    oauth_token_secret = (provider == 'twitter' ? oauth['credentials']['secret'] : nil)

    if provider && uid
      auth = Authentication.find_by_provider_and_uid(provider, uid)

      args = {provider: provider, uid: uid, email: email }
      args.merge!( oauth_token: oauth_token) if oauth_token
      args.merge!( oauth_token_secret: oauth_token_secret) if oauth_token_secret

      if current_user
        current_user.authentications.create!(args) unless auth
        redirect_to authentications_path
      else
        sign_in_and_redirect(:user, User.find_or_create(auth, args))
      end
    else
      render new_user_registration_path
    end
  end

  private

  def get_auth_token(provider, oauth)
    case provider
      when 'facebook', 'twitter' then oauth['credentials']['token']
      ### TODO: add vkontakte
      #when 'vk' then
      else nil
    end
  end
end
