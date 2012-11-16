class Geo::Osm::Poly < ActiveRecord::Base
  set_table_name "ways"
  attr_accessible :nodes, :tags
  serialize :tags, ActiveRecord::Coders::Hstore

  validates :id, :tags, :nodes, :presence => true

  def poly
    ordered_points = Array.new nodes.size
    Geo::Osm::Node.find(nodes).each do |n|
      #TODO get postgre bigint[] as array of integers
      ordered_points[ nodes.index n.id.to_s ] = n.geom
    end
    Geo::factory.polygon Geo::factory.linear_ring ordered_points
  end

  def contains?(node)
    poly.contains? node.geom
  end

  def touches?(node)
    poly.touches? node.geom
  end

  def intersects?(other_poly)
    poly.intersects? other_poly.poly
  end
end