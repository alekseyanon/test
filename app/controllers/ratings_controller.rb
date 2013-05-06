class RatingsController < ApplicationController
  def general
    @users = User.all
  end

  def commentators
    @users = User.order('commentator')
  end

  def bloggers
    @users = User.order('blogger')
  end

  def photographers
    @users = User.order('photographer')
  end

  def experts
    @users = User.order('expert')
  end

  def discoverers
    @users = User.order('discoverer')
  end
end
