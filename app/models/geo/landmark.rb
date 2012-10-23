class Geo::Landmark < ActiveRecord::Base
  belongs_to :node, :class_name => Geo::Osm::Node
  attr_accessible :name, :node_id, :tag_list #TODO remove hack: accessible node id

  validates :name, :node, :presence => true
  validates_associated :node

  acts_as_taggable #TODO cover in specs
end
