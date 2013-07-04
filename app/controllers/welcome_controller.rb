# Тестовый контроллер для рутовой странички.
# В последствии необходимо будет удалить.
#TODO mind the test controller
class WelcomeController < ApplicationController
  before_filter :load_search_history, only: :home

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

  def to_social_network
    current_user.authentications.where(provider: params[:provider]).first.social_post(params[:provider], Time.now.to_s)
    redirect_to root_path
  end
  def about
  end
  
  def sitemap
  end

  def terms
  end
end
