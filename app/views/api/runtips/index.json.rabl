extends "api/shared/rating"
extends "api/shared/complaints"

collection @runtips
attributes :id, :body, :created_at


child :user do
  attributes :id
  code(:username) { |m| m.profile.name || m.email || "Пользователь #{u.id}"}
  code(:link_to_profile) { |m| profile_path(m.profile) }
end
