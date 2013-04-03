module Searchable
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # Searches descriptions against title, body, tags, using upper level categories used as facets.
    # For queries with geospatial part, search is done within a radius of some point.
    #
    # @param [String, Hash] query 'query string' or {text: 'query string', geom: RGeo::Feature::Point, r: radius}
    #     or {text: 'query string', x: latitude, y: longitude, r: radius}
    #     or {facets: 'food,lodging', text: 'query string', x: latitude, y: longitude, r: radius}
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
        chain = chain.within_radius(geom, r) if geom
        text = query[:text]
        chain = chain.within_date_range query[:from], query[:to] if query[:from]
      end
      chain = chain.text_search(text) unless text.blank?
      if self.kind_of? AbstractDescription
        chain.where("abstract_descriptions.title != 'NoName'") #TODO remove hack
        chain.limit 20 if self.kind_of? AbstractDescription #TODO remove hack
      else
        chain
      end
    end
  end
end
