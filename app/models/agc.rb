class AGC < ActiveRecord::Base
  attr_accessible :relations
  has_many :geo_units

  def self.initialize
    #TODO consider introducing a model for 'relations' table
    ActiveRecord::Base.connection.raw_connection.prepare(
        'agc_names',
        "select tags->'name' as name from relations where id = $1")
  end

  def names
    relations.map { |id| AGC.connection.raw_connection.exec_prepared('agc_names', [id]).first['name'] }
  end
end