class Osm::Poly < ActiveRecord::Base
  self.table_name = 'ways'
  attr_accessible :nodes, :tags
  serialize :tags, ActiveRecord::Coders::Hstore

  validates :id, :tags, :nodes, :presence => true

  set_rgeo_factory_for_column(:geom, Geo::factory)

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
