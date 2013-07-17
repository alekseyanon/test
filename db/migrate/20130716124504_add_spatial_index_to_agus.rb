class AddSpatialIndexToAgus < ActiveRecord::Migration
  def up
    execute <<-SQL
          CREATE INDEX index_agus_on_geom ON agus USING GIST ( geom );
    SQL
  end
  def down
    execute <<-SQL
     DROP INDEX index_agus_on_geom;
    SQL
  end
end
