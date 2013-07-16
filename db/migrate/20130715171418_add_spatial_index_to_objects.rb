class AddSpatialIndexToObjects < ActiveRecord::Migration
  def up
    execute <<-SQL
          CREATE INDEX index_geo_objects_on_geom ON geo_objects USING GIST ( geom );
    SQL
  end
  def down
    execute <<-SQL
     DROP INDEX index_geo_objects_on_geom;
    SQL
  end
end
