class Geo::Osm::Poly < ActiveRecord::Base
  set_table_name "ways"
  attr_accessible :nodes, :tags
  serialize :tags, ActiveRecord::Coders::Hstore

  validates :id, :tags, :nodes, :presence => true
end