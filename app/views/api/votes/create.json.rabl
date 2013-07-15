node(:positive)   { @parent.votes_for(@tag) }
node(:negative)   { @parent.votes_against(@tag)}
node(:user_vote)  { current_user.get_vote(@parent, @tag) if current_user}
