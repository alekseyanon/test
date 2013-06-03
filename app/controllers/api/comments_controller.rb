class Api::CommentsController < ApplicationController
  before_filter :load_commentable
  
  def create
    @comment = @commentable.comments.build params[:comment]
    @comment.user = current_user
    @comment.parent_id = params[:parent_id]
    @comment.save
    @comment
  end

  def update
  end

  def destroy
  end

  def show
  end

  def index
    @comments = GeoObject.find(params[:object_id]).reviews
                         .find(params[:review_id]).comments
  end

end
