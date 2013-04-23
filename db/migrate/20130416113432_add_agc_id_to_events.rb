class AddAgcIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :agc_id, :integer
    add_index :events, :agc_id
  end
end
