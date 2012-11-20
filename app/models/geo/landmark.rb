class Geo::Landmark < ActiveRecord::Base
  belongs_to :node, :class_name => Geo::Osm::Node
  attr_accessible :name, :node_id, :tag_list #TODO remove hack: accessible node id

  validates :name, :node, :presence => true
  validates_associated :node

  acts_as_taggable #TODO cover in specs

  def self.by_tags_count(tag_list)
    if tag_list && !tag_list.empty?
      Geo::Landmark.tagged_with(tag_list, any: true).sort_by!{|l| -(l.tag_list & tag_list).length}
    else
      Geo::Landmark.all
    end
  end

  scope :within_radius, ->(geom,r) do
    joins(:node).where "ST_DWithin(nodes.geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end
end
