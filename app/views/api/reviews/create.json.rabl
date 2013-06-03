extends 'api/shared/user_complaint_rating_for_create'

object @review
attributes :id, :title, :body, :created_at

node(:comments_count) { |r| "#{r.comments.count} коментариев"}
