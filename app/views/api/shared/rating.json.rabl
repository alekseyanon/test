node :rating do |r|
  parent_model = if r.respond_to? :geo_object
                   r.geo_object 
                 elsif r.respond_to? :reviewable
                   r.reviewable
                 else
               	   r
                 end
  {
    votes_for: r.votes_for,
    votes_against: r.votes_against,
    current_user_vote: r.user.get_vote(r),
    vote_link: new_vote_polymorphic_path(parent_model),
    vote_reset_link: destroy_vote_polymorphic_path(parent_model)
  }
end
