class Api::ReviewsController < ApplicationController
  before_filter :find_parent_model, only: [:create, :index]
  
  def create
    @review = @parent.reviews.build params[:review]
    @review.user = current_user
    @review.save
    @review
  end

  def update
  end

  def destroy
  end

  def show
  end

  def index
    @reviews = @parent.reviews
  end

end
