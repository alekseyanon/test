collection @runtips
attributes :id, :body, :created_at


child :user do
  attributes :id
  code(:username) { |m| m.try(:name) || m.try(:email) || "Пользователь #{u.id}"}
  code(:link_to_profile) { |m| profile_path(m.profile) }
end


node :rating do |r|
  {
    votes_for: r.votes_for,
    votes_against: r.votes_against,
    current_user_vote: r.user.get_vote(r),
    vote_link: polymorphic_path([r.geo_object, r, r.votes.build]),
    vote_reset_link: polymorphic_path([r.geo_object, r, Vote.first])
  }
end

node :complaint do |r|
  # TODO: remove these stubs 
  {
    url: "some/path" ,
    current_user: true
  }
end
