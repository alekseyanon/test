def to_points(crd)
  crd.map{|x,y| Geo::factory.point x, y }
end

def to_nodes(crd)
  crd = to_points crd if crd[0].is_a? Array
  crd.map{|p| Geo::Osm::Node.make! geom: p }
end

def to_poly(nodes)
  Geo::Osm::Poly.make! nodes: nodes.map(&:id)
end

def to_landmarks(crd)
  to_nodes(crd).map{|n| Geo::Landmark.make!(node: n)}
end
