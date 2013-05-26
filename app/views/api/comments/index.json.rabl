extends "api/shared/rating"
extends "api/shared/complaints"

collection @comments
attributes :id, :body, :created_at


child :user do
  code(:username) { |m| m.try(:name) || m.try(:email) || "Пользователь #{u.id}"}
  code(:avatar) { |m| m.profile.avatar.store_dir }
end
