class Api::CommentsController < ApplicationController
  
  def create
  end

  def update
  end

  def destroy
  end

  def show
  end

  def index
    @comments = Review.find(params[:review_id]).comments
  end

end
