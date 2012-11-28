class GeoUnit < ActiveRecord::Base
  belongs_to :osm, :polymorphic => true
  has_one :description, :as => :describable
  attr_accessible :name, :osm_id, :osm_type, :tag_list #TODO remove hack: accessible osm_id, osm_type

  validates :osm, :presence => true
  validates_associated :osm
end
