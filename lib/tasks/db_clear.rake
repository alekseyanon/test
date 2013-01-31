namespace :db do
  desc "drop all table except osmosis"
  task clear: :environment do
    conn = ActiveRecord::Base.connection
    exceptions = %w(
      geography_columns
      geometry_columns
      raster_columns
      raster_overviews
      nodes
      relation_members
      relations
      schema_info
      spatial_ref_sys
      way_nodes
      ways
    )
    r = conn.execute "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"
    r = conn.execute "ALTER TABLE ways DROP COLUMN geom"
    r.each do |row|
      table_name = row['table_name']
      if !exceptions.include? table_name
        puts table_name
        conn.execute "DROP TABLE #{table_name}"
      end
    end
    puts "Drop column geom from WAYS table"
    conn.execute "ALTER TABLE ways DROP COLUMN geom"
  end
end
