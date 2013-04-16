# -*- encoding : utf-8 -*-
class AuthenticationsController < ApplicationController

	### TODO: add view for this action
	def index
    @authentications = current_user ? current_user.authentications.all : []
    #@connected_providers = @authentications.map { |auth| auth.provider }
  end

	def destroy
    service_name = @authentication.provider.titleize
    @authentication.destroy
    flash[:notice] = I18n.t("authentications.delete_success", :service => service_name)
    redirect_to edit_user_path(current_user)
  end


  ### TODO: мы считаем что пользователи могут логиниться
  ###       только под предложенными нами аккаунтами.
  def create
    #render text: request.env['omniauth.auth'].to_yaml
    oauth = request.env['omniauth.auth']
    unless oauth
      render text: 'No response'
      return
    end
    ### Working for twitter and facebook
    provider = oauth['provider']
    uid = oauth['uid']
    email = (params[:provider] == 'facebook' ? oauth['info']['email'] : nil)
    if provider && uid
      auth = Authentication.find_by_provider_and_uid(provider, uid)
      # Пользователь залогинен
      if current_user
        # у залогиненного пользователя найдена authentication модель
        if auth
          flash[:notice] = 'Your account is already connected with smorodina.'
          redirect_to authentications_path
        else  # У залогиненного пользователя не найдена authentication
          current_user.authentications.create!(email: email, provider: provider, uid: uid)
          if email && current_user.email.blank?
            current_user.update_attributes(email: email)
          end
          flash[:notice] = 'Your account has been connected for signing in smorodina.'
          redirect_to authentications_path
        end
      else # Пользователь не вошел на сайт
        if auth # Пользователь не вошел в систему, но authentication найдена
          # залогинить пользователя.
          if email && (user = auth.user).email.blank?
            user.update_attributes(email: email)
          end
          flash[:notice] = 'Signed in successfully via ' + provider.capitalize + '.'
          sign_in_and_redirect(:user, auth.user)
        else # Пользователь не вошел на сайт и authentication не найдена
          # найти или создать пользователя, создать authentication и залогинить его

          #поиск пользователя по email
          user = (email ? User.find_by_email(email) : nil)
          if user
            #Создаем authentication и залогиниваем пользователя
            user.authentications.create!(email: email, provider: provider, uid: uid)
            flash[:notice] = 'Signed in successfully via ' + provider.capitalize + '.'
            sign_in_and_redirect(:user, user)
          else
            # Создаем пользователя и authentication и залогиниваем его.
            args = {password: Devise.friendly_token[0,20]}
            args.merge! email: email if email
            user = User.new args
            user.authentications.build(provider: provider, uid: uid)
            user.skip_confirmation!
            user.save!
            user.confirm!
            flash[:myinfo] = 'Your account on Smorodina.com has been created via ' + provider.capitalize + '.
                              In your profile you can change your personal information.'
            sign_in_and_redirect(:user, user)
          end
          #render new_user_registration_path
        end
      end
    end
  end
end
