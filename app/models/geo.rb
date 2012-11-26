module Geo
  SRID = 4326
  def self.table_name_prefix
    'geo_'
  end

  def self.factory
    RGeo::Geos.factory(:srid => SRID)
  end
end
