# # -*- encoding : utf-8 -*-
# class UserSessionsController < ApplicationController
#   def new
# 	  @user_session = UserSession.new
#   end


#   ### Handle of creating session for social networks and through the email
#   def create
#     is_social_signup = params[:user_session].delete(:social_signup)
#     @user_session = UserSession.new(params[:user_session])
#     connection = session[:social_connection] if is_social_signup

#     if @user_session.save
#       flash[:notice] = I18n.t("user_sessions.successfull.login")
#       if connection
#         @user_session.user.authentications.create(:provider => connection[:provider], :uid => connection[:uid])
#         session[:social_connection] = nil
#         redirect_back_or_default auth_list_url
#       else
#         redirect_back_or_default root_url
#       end
#     else
#       flash[:error] = I18n.t("user_sessions.errors.login")

#       respond_to do |format|
#         format.html do
#           @user = User.new
#           render :template => "users/profile" 
#           #redirect_to profile_url(:type => "traveler")
#         end
#         format.js do
#           if is_social_signup
#             @service_name = connection[:provider].titleize
#             @user_name = connection[:user_name]
#             #render :partial => "authentications/question_popup"
#             redirect_to root_url
#           else
#             render :action => :new, :layout => false
#           end
#         end
#       end
#     end
#   end

#   # TODO: add view for this action
#   def confirm_destroy
#   end

#   def destroy
#   	@user_session = UserSession.find
# 	  session[:return_to] = nil
# 	  @user_session.destroy
# 	  redirect_to root_url
#   end

#   def current_user_info
#     respond_to do |format|
#       format.json { render :json => user_logged_in? ? user_json(current_user) : unauthorized_json }
#     end
#   end

#   private

#   def user_json(user)
#     # image_filename = user.image.big.small.url if user.image.present?
#     # image_filename ||= user.external_picture_url || user.image.big.small.default_url

#     data = {
#       :id           => user.id,
#       :email        => user.email,
#       :username     => user.name,
#       # :image_url    => view_context.image_path(image_filename),
#       :profile_url  => user_url(user)
#     }

#     ActiveSupport::JSON.encode(data)
#   end

#   def unauthorized_json
#     ActiveSupport::JSON.encode({:unauthorized => true})
#   end

# end
