child :user do
  attributes :id
  code(:username) { |m| m.try(:username)}
  code(:link_to_profile) { |m| profile_path(m.profile) }
  code(:avatar) { |m| m.avatar_url(:image_author_thumb) }
end
