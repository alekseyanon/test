class Agu < ActiveRecord::Base
  # Административно георафическая единица (юнит)
  include PgSearch
  include Searchable
  attr_accessible :geom, :place, :title
  validates :title, :geom, presence: true
  pg_search_scope :text_search, against: {title: 'A'}

  def agcs
    Agc.where('? = ANY(agcs.agus)', id)
  end
  
  # Определяет город по ip из таблицы Agu
  def self.by_ip(ip)
    client_city = location_by_ip(ip)
    if client_city && agu_location = where(title: client_city).first
      c = agu_location.geom.centroid
      [c.x, c.y]
    else
      Rails.logger.warn "No match found in agus for city #{client_city}" if client_city
      nil
    end
  end

  def agc_titles
    agc = self.agcs.first
    if agc
      agc.agus[0] == (id = self.id) ? {id => self.title} : agc.titles
    else
      ''
    end
  end

  def to_map_bounds scale = 1.01
    res = ActiveRecord::Base.connection.execute "SELECT ST_AsGeoJSON(ST_Scale(ST_Envelope(geom), #{scale}, #{scale})) 
                                                 FROM agus WHERE id = #{id}"
    coords = JSON.parse( res.first['st_asgeojson'] )['coordinates'].flatten(1)
    [ coords[0], coords[2] ] # SouthWest and NorthEast
  end
  
  private

  def self.location_by_ip ip
    begin
      if c = SxGeo.new.get(ip)
        c['city'].force_encoding('UTF-8')
      end
    rescue
      Rails.logger.warn "No city found for ip #{ip}"
      nil
    end
  end

end
