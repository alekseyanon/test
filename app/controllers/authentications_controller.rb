# -*- encoding : utf-8 -*-
class AuthenticationsController < ApplicationController
	load_and_authorize_resource :except => [:new, :create]

	### TODO: add view for this action
	def index
    @authentications = current_user.authentications.all
    @connected_providers = @authentications.map { |auth| auth.provider }
  end

	def destroy
    service_name = @authentication.provider.titleize
    @authentication.destroy
    flash[:notice] = I18n.t("authentications.delete_success", :service => service_name)
    redirect_to :action => :index
  end

end
