class CommentsController < InheritedResources::Base
  
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
      c.move_to_child_of parent
    end
    redirect_to r
  end  

end
