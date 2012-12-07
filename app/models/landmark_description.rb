class LandmarkDescription < AbstractDescription
  has_one :osm, through: :describable

  validates_associated :describable
  accessible_attributes :geo_unit_id #TODO remove hack: accessible geo_unit_id

  scope :within_radius, ->(geom, r) do
    joins("INNER JOIN geo_units ON abstract_descriptions.describable_id = geo_units.id
           INNER JOIN nodes ON geo_units.osm_id = nodes.id").
        where "ST_DWithin(nodes.geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end

  pg_search_scope :text_search,
                  against: {title: 'A', body: 'B'},
                  associated_against: {tags: [:name]}

  # Searches landmark descriptions against title, body, tags.
  # For queries with geospatial part, search is done within a radius of some point.
  #
  # @param [String, Hash] query 'query string' or {text: 'query string', geom: RGeo::Feature::Point, r: radius}
  #     or {text: 'query string', x: latitude, y: longitude, r: radius}
  # @return ActiveRecord::Relation all matching descriptions
  def self.search(query)
    return all unless query && !query.empty?
    if query.is_a? String
      text = query
    else
      query = query.delete_if { |k, v| v.nil? || (v.is_a?(String) && v.empty?) }
      text = query[:text]
      geom = query[:geom] || ((y = query[:x]) && (x = query[:y]) && Geo::factory.point(x.to_f, y.to_f)) #TODO mind x y
      r = query[:r] || 0
    end
    chain = LandmarkDescription
    chain = chain.text_search(text) if text
    chain = chain.within_radius(geom, r) if geom
    chain.where("abstract_descriptions.title != 'NoName'").limit 20
  end

  def branches
    categories = Category.where(name_ru: self.tag_list).select([ :id, :name, :name_ru, :lft, :rgt, :parent_id])
    categories.map{|c| c.self_and_ancestors}
  end
end
