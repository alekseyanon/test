class RatingsController < ApplicationController
  def general
    @users = User.all
  end

  def commentators
    @users = User.order('commentator DESC')
  end

  def bloggers
    @users = User.order('blogger DESC')
  end

  def photographers
    @users = User.order('photographer DESC')
  end

  def experts
    @users = User.order('expert DESC')
  end

  def discoverers
    @users = User.order('discoverer DESC')
  end
end
