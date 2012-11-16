module Geo
  def self.table_name_prefix
    'geo_'
  end

  def self.factory
    RGeo::Geos.factory(:srid => 4326)
  end
end
