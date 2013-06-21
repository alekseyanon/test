extends 'api/shared/rating'
extends 'api/shared/complaints'
extends 'api/shared/date'

collection @comments
attributes :id, :body, :created_at, :parent_id

child :user do
  code(:username) { |m| m.try(:username)}
  code(:avatar) { |m| m.avatar_url(:image_author_thumb) }
end
