class Agc < ActiveRecord::Base
  attr_accessible :agus
  has_many :geo_objects
  has_many :events

  def titles
    Hash[agus.map { |id| [id, Agu.find(id).title] }]
  end

  def self.most_precise_enclosing(geom)
    #TODO consider setting SRID for geomfromtext, find a no-conversion way to pass geometry
    find_by_sql(["SELECT * from agcs A
                  WHERE
                    Safe_ST_Contains((
                      select geom from agus
                      where
                        id = A.agus[array_length(A.agus, 1)] limit 1), ST_GeomFromText( ? , #{Geo::SRID}))
                  ORDER BY
                    array_length(A.agus, 1) DESC
                  LIMIT 1", geom.as_text])[0]
  end
end
