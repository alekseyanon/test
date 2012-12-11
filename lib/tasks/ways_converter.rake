desc "Add field to ways whith coords of nodes in waypoint"
task ways_converter: :environment do
  at_once = 1000
  sql_drop_column = "ALTER TABLE ways DROP COLUMN IF EXISTS geom"
  sql_alter       = "ALTER TABLE ways ADD  COLUMN geom GEOMETRY(POLYGON, #{Geo::SRID})"
  polygon_and_not_building = "nodes[array_upper(nodes,1)] = nodes[1] and not tags ? 'building'"
  conn = ActiveRecord::Base.connection
  conn.execute sql_drop_column
  conn.execute sql_alter
  i = 0
  while ways = Osm::Poly.where(polygon_and_not_building).limit(at_once).offset(i*at_once) and ways.count > 0 do
    puts "*** #{i} ***"
    i += 1
    ways.each do |way|
      begin
        point_coords = []
        if way.nodes.count > 3
          coords_string = way.nodes.map{ |node_id|
              p = Osm::Node.find(node_id).geom
              "#{p.x} #{p.y}"}.join(', ')
          create_polygon_for_way way.id, coords_string
        else
          puts "Skip way #{way.id}"
        end
      rescue
        puts "### Can't import way: #{way.id}  ###"
      end
    end
  end
end

def create_polygon_for_way way_id, coords_string
  ActiveRecord::Base.connection.execute "UPDATE ways
    SET geom = ST_MakePolygon( ST_GeomFromText( 'LINESTRING(#{coords_string})', #{Geo::SRID}))
    WHERE id = #{way_id};"
end
