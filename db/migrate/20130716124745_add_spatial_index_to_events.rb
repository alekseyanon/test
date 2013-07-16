class AddSpatialIndexToEvents < ActiveRecord::Migration
  def up
    execute <<-SQL
          CREATE INDEX index_events_on_geom ON events USING GIST ( geom );
    SQL
  end
  def down
    execute <<-SQL
     DROP INDEX index_events_on_geom;
    SQL
  end
end
