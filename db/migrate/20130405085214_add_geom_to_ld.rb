class AddGeomToLd < ActiveRecord::Migration
  def change
    add_column :abstract_descriptions, :geom, 'geometry(Point,4326)'
  end
end
