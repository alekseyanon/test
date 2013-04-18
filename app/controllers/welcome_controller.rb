# Тестовый контроллер для рутовой странички.
# В последствии необходимо будет удалить.
#TODO mind the test controller
class WelcomeController < ApplicationController
  def home
  end

  def pend_act
  	@user = current_user
  end

  def new
  end
  def edit
  end
  def show
  end
  def history
  end

  def post

  end

  def to_twitter
    current_user.authentications.where(provider: 'twitter').first.twitter_post(Time.now.to_s)
    redirect_to root_path
  end

  def to_facebook
    current_user.authentications.where(provider: 'facebook').first.facebook_post(Time.now.to_s)
    redirect_to root_path
  end
end
