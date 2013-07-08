class CommentsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_comment, only: [:update, :edit]
  before_filter :load_commentable
  load_and_authorize_resource only: CRUD_ACTIONS

  def new
    @comment = @commentable.comments.build
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @comment = @commentable.comments.build params[:comment]
    @comment.user = current_user
    @comment.parent_id = params[:parent_id]
    if @comment.save
      respond_with do |format|
        format.html { redirect_to @commentable }
        format.js { render '_record', locals: { comment: @comment, sub_comments: nil }}
      end
    else
      respond_with do |format|
        format.html { render action: :new }
        format.json { render json: @commentable.errors, status: :unprocessable_entity }
        format.js { render '_add_comment', locals: {commentable: @commentable, comment: @comment }}
      end
    end
  end

  def update
    respond_with do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @commentable, notice: 'comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
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

end
