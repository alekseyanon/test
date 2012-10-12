class Geo::Osm::Node < ActiveRecord::Base
  set_table_name "planet_osm_nodes"
  class Tags
    include PgArrayParser
    def load(text)
      return unless text
      Hash[*parse_pg_array(text)]
    end
    def dump(hash)
      "{#{hash.to_a.join ","}}"
    end
  end
  attr_accessible :lat, :lon, :tags
  serialize :tags, Tags.new
end
