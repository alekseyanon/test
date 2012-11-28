module Geo
  SRID = 4326

  def self.factory
    RGeo::Geos.factory(:srid => SRID)
  end
end
