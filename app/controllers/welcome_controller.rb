# Тестовый контроллер для рутовой странички. 
# В последствии необходимо будет удалить.
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
end
