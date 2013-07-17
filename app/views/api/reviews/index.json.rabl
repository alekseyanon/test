extends 'api/shared/rating'
extends 'api/shared/complaints'
extends 'api/shared/date'
extends 'api/shared/comments'
extends 'api/shared/user'

collection @reviews
attributes :id, :body, :title, :created_at
