node :rating do |r|
  {
    votes_for: r.votes_for,
    votes_against: r.votes_against,
    current_user_vote: current_user.nil? ? 0 : current_user.get_vote(r),
    vote_url: new_vote_polymorphic_path(r),
  }
end
