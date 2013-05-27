node :rating do |r|
  {
    votes_for: r.votes_for,
    votes_against: r.votes_against,
    current_user_vote: current_user.get_vote(r),
    vote_link: new_vote_polymorphic_path(r),
    vote_reset_link: new_vote_polymorphic_path(r)
  }
end
