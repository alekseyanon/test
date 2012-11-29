class CreateGeoUnits < ActiveRecord::Migration
  def change
    create_table :geo_units do |t|
      t.references :osm
      t.string :osm_type
      t.string :type
      t.timestamps
    end
    add_index :geo_units, :osm_id
  end
end
