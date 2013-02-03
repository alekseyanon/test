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
    c.save!
    if !params[:parent_id].blank?
      parent = Comment.find params[:parent_id]
      c.update_attribute :parent, parent if parent
    end
    redirect_to r
  end  

end
