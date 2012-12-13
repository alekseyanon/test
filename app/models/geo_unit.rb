class GeoUnit < ActiveRecord::Base
  belongs_to :osm, polymorphic: true
  has_one :description, as: :describable
  attr_accessible :osm_id, :osm_type, :tag_list #TODO remove hack: accessible osm_id, osm_type

  validates :osm, presence: true
  validates_associated :osm

  scope :within_radius_scope, ->(geom, r , table_name) do
    joins( "INNER JOIN #{table_name} ON #{table_name}.id = geo_units.osm_id").
        where "ST_DWithin(#{table_name}.geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end

end
