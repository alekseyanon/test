class AddRatingToEvents < ActiveRecord::Migration
  def change
    add_column :events, :rating, :integer, default: 0
  end
end
