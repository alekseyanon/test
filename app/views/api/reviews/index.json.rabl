extends "api/shared/rating"
extends "api/shared/complaints"

collection @reviews
attributes :id, :body, :title, :created_at

node(:comments_count) { |r| "#{r.comments.count} коментариев"}

child :user do
  attributes :id
  code(:username) { |m| m.profile.name || m.email || "Пользователь #{u.id}"}
  code(:link_to_profile) { |m| profile_path(m.profile) }
  code(:avatar) { |m| m.profile.avatar_url(:image_author_thumb) }
end
