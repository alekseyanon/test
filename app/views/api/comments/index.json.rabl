extends 'api/shared/rating'
extends 'api/shared/complaints'
extends 'api/shared/date'
extends 'api/shared/user'

collection @comments
attributes :id, :body, :created_at, :parent_id
