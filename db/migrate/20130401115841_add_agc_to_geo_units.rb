class AddAgcToGeoUnits < ActiveRecord::Migration
  def change
    add_column :geo_units, :agc_id, :integer
  end
end
