def to_nodes(crd)
  crd.map{|x,y| Geo::Osm::Node.make!(geom: Geo::factory.point(x, y))}
end

def to_poly(nodes)
  Geo::Osm::Poly.make! nodes: nodes.map(&:id)
end
