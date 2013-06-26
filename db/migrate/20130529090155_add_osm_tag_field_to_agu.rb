class AddOsmTagFieldToAgu < ActiveRecord::Migration
  def change
    add_column :agus, :osm_tags, :hstore
  end
end
