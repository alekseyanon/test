module Geo
  def self.table_name_prefix
    'geo_'
  end

  def self.factory
    RGeo::Geographic.spherical_factory(:srid => 4326)
  end
end
