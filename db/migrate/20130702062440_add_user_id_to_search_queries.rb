class AddUserIdToSearchQueries < ActiveRecord::Migration
  def change
    add_column :search_queries, :user_id, :integer
  end
end
