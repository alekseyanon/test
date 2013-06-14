extends 'api/shared/user_complaint_rating_for_create'
extends 'api/shared/date'

object @review
attributes :id, :title, :body, :created_at

node(:comments_count) { '0 коментариев' }
