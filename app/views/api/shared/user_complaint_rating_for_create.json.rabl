child :user do
  attributes :id
  code(:username) { |m| m.try(:username)}
  code(:link_to_profile) { |m| profile_path(m.profile) }
  code(:avatar) { |m| m.avatar_url(:image_author_thumb) }
end

node :complaint do |r|
  {
      url: new_complaint_polymorphic_path(r),
      current_user: 0
  }
end

node :rating do |r|
  {
      votes_for: 0,
      votes_against: 0,
      current_user_vote: 0,
      vote_url: new_vote_polymorphic_path(r),
  }
end
