# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  # def new
  # 	@user = User.new
  # end

  def new
    @user = User.new
    logger.debug "'''''''''''''''''''''''''''''''''''''''''"
    logger.debug params[:type]
    @user.roles = [params[:type].to_sym]
    # logger.debug "****************roles*********************"
    # logger.debug params[:type]
  end

  def create
	  # @user = User.new(params[:user])
	  # if @user.save
	  #   flash[:notice] = "Registration successful."
	  #   redirect_to root_url
	  # else
	  #   render :action => 'new'
	  # end
	  logger.debug "++++++++++++++METHOD:"
    logger.debug "START NEW USER MATHOD"
    logger.debug params[:type]
	  @user = User.new_user(params[:type], params[:user])
	  logger.debug "++++++++++++++METHOD:"
    logger.debug "START register METHOD"
	  if @user.register
	  	redirect_to root_url
	  	logger.debug "*******************************"
	  	logger.debug "registered"
	  else
	  	render :action => :new
	  	logger.debug "---------------------------------"
	  	logger.debug "something wrong durring the registration"
	  end
	end

  # def edit
  # 	@user = User.find(params[:user])
  # end
  def edit
	  @user = current_user
	end

	def update
	  @user = current_user
	  if @user.update_attributes(params[:user])
	    flash[:notice] = "Successfully updated profile."
	    redirect_to root_url
	  else
	    render :action => 'edit'
	  end
	end
end
