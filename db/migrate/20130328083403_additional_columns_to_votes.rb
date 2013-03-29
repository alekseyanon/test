class AdditionalColumnsToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :voteable_tag, :string
  end
end
