class BigintGeoUnits < ActiveRecord::Migration
  def change
    change_column :geo_units, :osm_id, :integer, limit: 8
  end
end
