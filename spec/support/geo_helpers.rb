def to_points(crd)
  crd.map{|x,y| Geo::factory.point x, y }
end

def to_nodes(crd)
  crd = to_points crd if crd[0].is_a? Array
  crd.map{|p| Osm::Node.make! geom: p }
end

def to_events(crd)
  crd = to_points crd if crd[0].is_a? Array
  crd.map{|p| Event.make! geom: p }
end

def to_poly(nodes)
  Osm::Poly.make! geom: Geo.factory.polygon(Geo.factory.line_string nodes.map(&:geom))
end

def to_landmarks(crd)
  to_nodes(crd).map{|n| Landmark.make!(osm: n)}
end

def landmarks_to_descriptions(landmarks)
  landmarks.map{|lm| LandmarkDescription.make! describable: lm}
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

def load_categories
  load "#{Rails.root}/db/seeds.rb"
end

def load_descriptions
  File.open("#{Rails.root}/db/seeds/landmark_descriptions.yml"){|f| YAML.load f.read}.map do |yld|
    dc = described_class.make! yld.slice(:title, :body)
    if defined? dc.tag_list    
      dc.tag_list += yld[:tags] if yld[:tags] #TODO move to blueprints
    end
    dc.save
    dc
  end
end
