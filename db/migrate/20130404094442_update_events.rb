class UpdateEvents < ActiveRecord::Migration
  def change
    remove_column :events, :schedule
    remove_column :events, :duration
    add_column :events, :end_date, :datetime
    add_column :events, :archive_date, :datetime
    remove_column :events, :image
    add_column :events, :state, :string
    add_column :events, :key, :string
    add_column :events, :published_at, :datetime
    remove_column :events, :landmark_id
  end
end
