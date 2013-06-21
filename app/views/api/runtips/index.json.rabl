extends 'api/shared/rating'
extends 'api/shared/complaints'
extends 'api/shared/date'

collection @runtips
attributes :id, :body, :created_at

child :user do
  attributes :id
  code(:username) { |m| m.try(:username)}
  code(:link_to_profile) { |m| profile_path(m.profile) }
end
