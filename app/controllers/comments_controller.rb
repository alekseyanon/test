class CommentsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]

  def new
    @review = Review.find params[:review_id]
    @comment = @review.comments.build
    new!
  end

  def edit
    @review = Review.find params[:review_id]
    @comment = Comment.find params[:id]
    edit!
  end

  def create
    @review = Review.find params[:review_id]
    @comment = @review.comments.build params[:comment]
    @comment.user = current_user
    @comment.parent_id = params[:parent_id]
    if @comment.save
      redirect_to @review
    else
      respond_with do |format|
        format.html { render action: :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
    #redirect_to @review
  end

  def update
    @review = Review.find params[:review_id]
    @comment = Comment.find params[:id]
    respond_with do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @review, notice: 'review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
end
