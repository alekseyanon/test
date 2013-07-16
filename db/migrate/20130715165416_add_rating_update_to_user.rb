class AddRatingUpdateToUser < ActiveRecord::Migration
  def change
    add_column :users, :rating_updated_at, :datetime
  end
end
