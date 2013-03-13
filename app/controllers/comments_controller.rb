class CommentsController < InheritedResources::Base
  before_filter :authenticate_user!, except: [:index, :show]

  def new
    @review = Review.find params[:review_id]
    @comment = @review.comments.build
    new!
  end

  def create
    r = Review.find params[:review_id]
    c = r.comments.build params[:comment]
    c.user = current_user
    c.parent_id = params[:parent_id]
    c.save!
    redirect_to r
  end
end
