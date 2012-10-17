class Geo::Landmark < ActiveRecord::Base
  belongs_to :node, :class_name => Geo::Osm::Node
  attr_accessible :name, :node_id
  acts_as_taggable
end
