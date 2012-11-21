class ResetPasswordController < ApplicationController
	before_filter :find_with_perishable_token, :only => [:passwrod_form, :update_password ]
	def forget_password
	end

	def send_instruction
		email = params[:email]
		@user = User.find_by_email(email)
		if @user
			@user.reset_perishable_token!
			@user.reload
			Notifier.reset_pass(@user).deliver
			redirect_to root_url, :notice => I18n.t("reset_password.notice.notification_by_email") + email
		else
      flash[:error] = I18n.t("reset_password.errors.send_instruction")
      @error = I18n.t("reset_password.errors.send_instruction")
      render :action => 'forget_password'
    end
	end

	def passwrod_form
  end

  def update_password
    if @user
      @user.password = params[:password]
      @user.password_confirmation = params[:password]
      if @user.save
        redirect_to @user
      else
        @error = I18n.t("users.actions.update_password.error")
        redirect_to root_url, :error => I18n.t("users.actions.update_password.error")
      end

    end
  end

  private
  	def find_with_perishable_token
  		@user = User.find_using_perishable_token(params[:token], 6.hours)
      if @user.nil?
        flash[:error] = I18n.t("users.errors.find_by_perishable_token")
        redirect_to root_url
      end
  	end
end
