class Api::CommentsController < ApplicationController
  before_filter :load_commentable, only: [:create]
  before_filter :find_parent_model, only: [:index]

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
    @comments = @parent.comments
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[2, 3]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

end
