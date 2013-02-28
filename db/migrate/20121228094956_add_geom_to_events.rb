class AddGeomToEvents < ActiveRecord::Migration
  def up
    execute "ALTER TABLE events ADD  COLUMN geom GEOMETRY(POINT, #{Geo::SRID})"
  end
  def down
    execute 'ALTER TABLE events DROP COLUMN geom'
  end
end
