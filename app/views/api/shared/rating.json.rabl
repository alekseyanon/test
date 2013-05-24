node :rating do |r|
  {
    votes_for: r.votes_for,
    votes_against: r.votes_against,
    current_user_vote: r.user.get_vote(r),
    vote_link: polymorphic_path([r.geo_object, r, r.votes.build]),
    vote_reset_link: polymorphic_path([r.geo_object, r, Vote.first])
  }
end