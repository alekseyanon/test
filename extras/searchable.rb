module Searchable
  def self.included(base)
    base.send :extend, ClassMethods
    base.scope :bounding_box, ->( xmin, ymin, xmax, ymax) do
      base.where('geom && ST_MakeEnvelope(?,?,?,?,?)', xmin, ymin, xmax, ymax, Geo::SRID)
    end
  end

  module ClassMethods

    def within_radius geom, r
      where "ST_DWithin(geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
    end

    # Searches descriptions against title, body, tags, using upper level categories used as facets.
    # For queries with geospatial part, search is done within a radius of some point.
    #
    # @param [String, Hash] query 'query string' or {text: 'query string', geom: RGeo::Feature::Point, r: radius}
    #     or {text: 'query string', x: latitude, y: longitude, r: radius}
    #     or {facets: 'food,lodging', text: 'query string', x: latitude, y: longitude, r: radius}
    #     or {text: 'query string', x: latitude, y: longitude, r: radius, sort_by: rating}
    # @return ActiveRecord::Relation all matching descriptions
    def search(query)
      return all unless query && !query.empty?
      chain = self
      if query.is_a? String
        text = query
      else
        query.delete_if { |_, v| v.blank? }
        chain = chain.tagged_with query[:facets], any: true  if query[:facets]
        geom = query[:geom] || ((y = query[:x]) && (x = query[:y]) && Geo::factory.point(x.to_f, y.to_f)) #TODO mind x y
        r = query[:r] || 0
        if query[:bounding_box]
          chain = chain.bounding_box(*query[:bounding_box])
        elsif geom
          chain = chain.within_radius(geom, r)
        end
        chain = chain.in_place(query[:place_id]) if query[:place_id]
        text = query[:text]
        chain = chain.within_date_range query[:from], query[:to] if query[:from]
      end
      chain = chain.text_search(text) unless text.blank?
      if self.kind_of? GeoObject
        chain.where("title != 'NoName'") #TODO remove hack
        chain.limit 20  #TODO remove hack
      else
        chain
      end
    end

  end
end
