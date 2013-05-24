collection @runtips
attributes :id, :body, :created_at

child :user do
end

  #u = r.user
  #g = r.geo_object
  #{runtip: {id: r.id,
  #          body: r.body,
  #          date: r.created_at,
  #          user: {
  #              username: "Пользователь #{u.id}" || u.try(:email) || u.try(:name),
  #              link_to_profile: profile_path(u.profile)
  #          },
  #          rating: {
  #              votes_for: r.votes_for,
  #              votes_against: r.votes_against,
  #              current_user_vote: u.get_vote(r),
  #              vote_link: polymorphic_path([g, r, r.votes.build]),
  #              vote_reset_link: polymorphic_path([g, r, Vote.first])
  #          },
  #          complaint: {
  #              url: new_polymorphic_path([g, r, r.complaints.build]),
  #              current_user: u.complaint_for(r)
  #          }
  #}
  #}
