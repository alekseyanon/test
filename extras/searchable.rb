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
        chain = chain.within_date_range *query[:date] if query[:date]
      end
      chain = chain.text_search(text) unless text.blank?
      chain.where("abstract_descriptions.title != 'NoName'") if self.kind_of? AbstractDescription #TODO remove hack
      if query[:rateorder]
        chain = chain.joins("left outer join (
                       select voteable_type, voteable_id, count(distinct voteable_tag) cnt
                       from votes
                       group by voteable_id, voteable_type
                      ) c1 on abstract_descriptions.id = c1.voteable_id and
                              c1.voteable_type = 'AbstractDescription'
                    left outer join
                      (
                       select voteable_type, voteable_id, coalesce(count(*),0) as cnt
                       from votes
                       where vote = TRUE
                       group by voteable_id, voteable_type
                      ) c2 on abstract_descriptions.id = c2.voteable_id and
                              c2.voteable_type = 'AbstractDescription'")
        chain = chain.order("coalesce((c2.cnt::real / c1.cnt::real)::real, 0) desc, created_at ")
      end
      chain.limit 20 #TODO remove hack
    end
  end
end
