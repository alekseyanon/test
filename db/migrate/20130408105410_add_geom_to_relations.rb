class AddGeomToRelations < ActiveRecord::Migration
  def up
    execute "SELECT AddGeometryColumn('relations', 'geom', #{Geo::SRID}, 'POLYGON', 2)"
  end

  def down
    execute "SELECT AddGeometryColumn('relations', 'geom')"
  end
end
