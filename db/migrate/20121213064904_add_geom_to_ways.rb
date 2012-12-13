class AddGeomToWays < ActiveRecord::Migration
  def up
    execute "ALTER TABLE ways ADD  COLUMN geom GEOMETRY(POLYGON, #{Geo::SRID})"
  end
  def down
    execute 'ALTER TABLE ways DROP COLUMN geom'
  end
end
