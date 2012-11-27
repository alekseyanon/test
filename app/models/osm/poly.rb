class Osm::Poly < ActiveRecord::Base
  self.table_name = 'ways'
  attr_accessible :nodes, :tags
  serialize :tags, ActiveRecord::Coders::Hstore

  validates :id, :tags, :nodes, :presence => true

  def geom
    ordered_points = Array.new nodes.size
    Osm::Node.find(nodes).each do |n|
      #TODO get postgre bigint[] as array of integers
      ordered_points[ nodes.index n.id.to_s ] = n.geom
    end
    Geo::factory.polygon Geo::factory.linear_ring ordered_points
  end

  def contains?(node)
    geom.contains? node.geom
  end

  def touches?(node)
    geom.touches? node.geom
  end

  def intersects?(other_poly)
    geom.intersects? other_poly.geom
  end
end