module Searchable
  def self.included(base)
    base.send :extend, ClassMethods
  end
 
  module ClassMethods    

    # Searches objects against PGTextSearch and date if exists.
    # For queries with geospatial part, search is done within a radius of some point.
    #
    # @param [String, Hash] query 'query string' or {text: 'query string', geom: RGeo::Feature::Point, r: radius}
    #     or {text: 'query string', x: latitude, y: longitude, r: radius}
    #     or {text: 'query string', geom: RGeo::Feature::Point, r: radius, date: 'date condition'}
    # @return ActiveRecord::Relation all matching descriptions
    def search(query)
      return all unless query && !query.empty?
      if query.is_a? String
        text = query
      else        
        query = query.delete_if { |k, v| v.blank? }
        text  = query[:text]
        geom  = query[:geom] || ((y = query[:x]) && (x = query[:y]) && Geo::factory.point(x.to_f, y.to_f)) #TODO mind x y
        r     = query[:r] || 0
        date  = query[:date]
      end
      chain = self
      if date
        chain = chain.joins('JOIN event_occurrences ON event_occurrences.event_id = events.id')
        chain = chain.where date
      end    
      chain = chain.text_search(text) if text
      chain = chain.within_radius(geom, r) if geom
      chain.limit 20
    end

  end 

end