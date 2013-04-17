# fun coding: UTF-8

def to_point(crd)
  Geo::factory.point *crd
end

def to_points(crd)
  crd.map{|c| to_point c }
end

def to_node(crd)
  Osm::Node.make! geom:(crd.is_a?(Array) ? to_point(crd) : crd)
end

def to_nodes(crd)
  crd.map{|c| to_node c }
end

def to_events(crd)
  crd = to_points crd if crd[0].is_a? Array
  crd.map{|p| Event.make! geom: p }
end

def dates_to_events dates
  dates.map { |d| Event.make!(start_date: d) }
end

def to_poly(nodes)
  Osm::Poly.make! geom: Geo.factory.polygon(Geo.factory.line_string nodes.map(&:geom))
end

def to_geo_objects crds
  crds.map{ |crd| GeoObject.make! geom: (crd.is_a?(Array) ? to_point(crd) : crd)}
end

def get_foursquares(start_from)
  polygons = []
  start_from.each do |coord|
    polygons << Osm::Poly.make!(
        geom: Geo.factory.polygon(
            Geo.factory.line_string(
                [
                    Geo.factory.point(coord[0], coord[1]),
                    Geo.factory.point(coord[0]+10, coord[1]),
                    Geo.factory.point(coord[0]+10, coord[1]+10),
                    Geo.factory.point(coord[0], coord[1]+10),
                    Geo.factory.point(coord[0], coord[1])
                ]
            )))
  end
  polygons
end

def load_seeds
  load "#{Rails.root}/db/seeds.rb"
end

def load_descriptions
  File.open("#{Rails.root}/db/seeds/geo_objects.yml"){|f| YAML.load f.read}.map do |yld|
    dc = described_class.make! yld.slice(:title, :body)
    dc.tag_list = yld[:tags].join ', ' if defined?(dc.tag_list) && yld[:tags]
    dc.save
    dc
  end
end

def drop_relations
    ActiveRecord::Base.connection.execute 'delete from relations'
  end

# id_to_fields - хеш вида {id => {name: 'some text', geom: 'POINT(1,1)'}, ... }
def make_relations(id_to_fields)
  ActiveRecord::Base.connection.execute(
      id_to_fields.map do |id, fields|
        "insert into relations (id, version, user_id, tstamp, changeset_id, geom)
         values (#{id}, 1, 1, TIMESTAMP '2011-11-11 11:11:11', 1, #{fields.has_key?(:geom) ? "ST_GeomFromText('#{fields[:geom]}', #{Geo::SRID})" : 'null'});
         UPDATE relations SET tags = ('name' => '#{fields[:name]}') where id = #{id};"
      end.join)
end

# 3 квадрата вокруг 0,0
def make_sample_relations!
  make_relations({ 1 => {name: 'Россия', geom: to_poly(to_nodes([[-30, -30], [-30, 30], [30, 30], [30, -30], [-30, -30]])).geom},
                   2 => {name: 'Ленинградская область', geom: to_poly(to_nodes([[-20, -20], [-20, 20], [20, 20], [20, -20], [-20, -20]])).geom },
                   3 => {name: 'Санкт-Петербург', geom: to_poly(to_nodes([[-10, -10], [-10, 10], [10, 10], [10, -10], [-10, -10]])).geom }
                 })
end
