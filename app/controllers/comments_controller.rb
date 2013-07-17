class CommentsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_comment, only: [:update, :edit]
  before_filter :load_commentable
  load_and_authorize_resource only: CRUD_ACTIONS

  ### TODO: should be deleted. It need for images comments
  def new
    @comment = @commentable.comments.build
  end

  def create
    @comment = @commentable.comments.build params[:comment]
    @comment.user = current_user
    @comment.parent_id = params[:parent_id]
    if @comment.save
      respond_with_js '_record', { comment: @comment, sub_comments: nil }
    else
      respond_with_js '_add_comment', {commentable: @commentable, comment: @comment }
    end
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def find_comment
    @comment = Comment.find params[:id]
  end

  def respond_with_js partial, locals
    respond_with do |format|
      format.js { render partial, locals: locals}
    end
  end

end
