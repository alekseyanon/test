class Agc < ActiveRecord::Base
  attr_accessible :relations
  has_many :geo_units
  has_many :events

  #TODO consider introducing a model for 'relations' table
  ActiveRecord::Base.connection.raw_connection.prepare(
      'agc_names',
      "select tags->'name' as name from relations where id = $1")

  def names
    Hash[relations.map { |id| [id, Agc.connection.raw_connection.exec_prepared('agc_names', [id]).first['name']] }]
  end

  def self.most_precise_enclosing(geom)
    #TODO consider setting SRID for geomfromtext, find a no-conversion way to pass geometry
    find_by_sql(["SELECT * from agcs A
                  WHERE
                    Safe_ST_Contains((
                      select geom from relations
                      where
                        id = A.relations[array_length(A.relations, 1)] limit 1), ST_GeomFromText( ? , #{Geo::SRID}))
                  ORDER BY
                    array_length(A.relations, 1) DESC
                  LIMIT 1", geom.as_text])[0]
  end
end
