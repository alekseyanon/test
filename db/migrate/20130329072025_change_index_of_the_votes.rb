class ChangeIndexOfTheVotes < ActiveRecord::Migration
  def up
    remove_index :votes, name: 'fk_one_vote_per_user_per_entity'
    add_index :votes, [:voter_id, :voter_type, :voteable_id, :voteable_type, :voteable_tag],
              :unique => true, :name => 'fk_one_vote_per_user_per_entity'
  end
  def down
    remove_index :votes, name: 'fk_one_vote_per_user_per_entity'
  end
end
