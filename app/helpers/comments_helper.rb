module CommentsHelper
  def nested_comments(comments)
    comments.map do |comment, sub_comments|
      render(partial: 'comments/record', locals: {comment: comment, sub_comments: sub_comments}) 
		end.join.html_safe
  end
end
