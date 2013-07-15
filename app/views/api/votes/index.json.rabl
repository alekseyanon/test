object @parent

node :rating do |p|
  {
    id: p.id,
    votes_for: p.votes_for(@tag),
    votes_against: p.votes_against(@tag),
    current_user_vote: current_user.get_vote(p, @tag),
    vote_url: new_vote_polymorphic_path(p, @tag)
  }
end
