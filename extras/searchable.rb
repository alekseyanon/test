module Searchable
  def self.included(base)
    base.send :extend, ClassMethods
    base.scope :bounding_box, ->( xmin, ymin, xmax, ymax) do
      base.where('geom && ST_MakeEnvelope(?,?,?,?,?)', xmin, ymin, xmax, ymax, Geo::SRID)
    end

    base.scope :newest, base.order('created_at DESC')

    base.scope :newest_list, ->( window, offset) do
      base.order('created_at DESC').limit(window).offset(offset)
    end
  end

  module ClassMethods

    def within_radius geom, r
      where "ST_DWithin(geom, ST_GeogFromText('#{geom}'), #{r})"
    end

    def in_place place_id
      joins('JOIN agcs ON agc_id = agcs.id').where('? = ANY(agcs.agus)', place_id)
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
      return all if query.blank?
      memo = {chain: self}

      if query.is_a? String
        memo[:query] = {text: query}
      else
        memo[:query] = query
        check_facets memo
        check_geom memo
        check_place memo
        check_agc memo
        check_date_range memo
      end

      check_text memo

      if self <= GeoObject
        memo[:chain] = memo[:chain].where("title != 'NoName'") #TODO remove hack
        if query.is_a?(Hash) && query[:clusters]
          add_clustering memo[:chain], query[:clusters]
        else
          memo[:chain].limit 20  #TODO remove hack
        end
      else
        memo[:chain].limit 3
      end
    end

    def check_facets(memo)
      facets = memo[:query][:facets]
      memo[:chain] = memo[:chain].tagged_with facets, any: true if facets
    end

    def check_geom(memo)
      query = memo[:query]
      geom = query[:geom] || (y = query[:x]) && (x = query[:y]) && Geo::factory.point(x.to_f, y.to_f)
      r = query[:r] || 0
      if query[:bounding_box]
        memo[:chain] = memo[:chain].bounding_box *query[:bounding_box]
      elsif geom
        memo[:chain] = memo[:chain].within_radius geom, r
      end
    end

    def check_place(memo)
      place_id = memo[:query][:place_id]
      memo[:chain] = memo[:chain].in_place(place_id) if place_id
    end

    def check_agc(memo)
      agc_id = memo[:query][:agc_id]
      memo[:chain] = memo[:chain].with_agc(agc_id) if agc_id
    end

    def check_date_range(memo)
      from, to = memo[:query][:from], memo[:query][:to]
      memo[:chain] = memo[:chain].within_date_range from, to if from
    end

    def check_text(memo)
      text = memo[:query][:text]
      memo[:chain] = memo[:chain].text_search(text) unless text.blank?
    end

    def add_clustering(chain, clusters)
      Clustering.from_chain(chain, clusters).map do |c| #TODO remove hack - altered object with cluster centroid as geom
        go = GeoObject.find c[:member_ids][0]
        go.geom = c[:geom]
        go
      end
    end

  end
end
