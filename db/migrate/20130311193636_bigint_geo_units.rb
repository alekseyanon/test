class BigintGeoUnits < ActiveRecord::Migration
  def up
    change_column :geo_units, :osm_id, :integer, limit: 8
  end
  def down

  end
end
