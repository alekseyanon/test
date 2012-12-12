def to_points(crd)
  crd.map{|x,y| Geo::factory.point x, y }
end

def to_nodes(crd)
  crd = to_points crd if crd[0].is_a? Array
  crd.map{|p| Osm::Node.make! geom: p }
end

def to_poly(nodes)
  Osm::Poly.make! geom: Geo.factory.polygon(Geo.factory.line_string(nodes.map(&:geom)))
end

def to_landmarks(crd)
  to_nodes(crd).map{|n| Landmark.make!(osm: n)}
end

def landmarks_to_descriptions(landmarks)
  landmarks.map{|lm| LandmarkDescription.make! describable: lm}
end
