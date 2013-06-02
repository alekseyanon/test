extends "api/shared/rating"
extends "api/shared/complaints"

collection @comments
attributes :id, :body, :created_at, :parent_id


child :user do
  code(:username) { |m| m.profile.name || m.email || "Пользователь #{u.id}"}
  code(:avatar) { |m| m.profile.avatar_url(:image_author_thumb) }
end
