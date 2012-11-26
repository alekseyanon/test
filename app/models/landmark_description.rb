class LandmarkDescription < Article
  belongs_to :landmark, :class_name => Geo::Landmark
  has_many :tags, through: :landmark
  has_one :node, through: :landmark

  validates_associated :landmark
  accessible_attributes :landmark_id

  scope :within_radius, ->(geom, r) do
    joins(:node).where "ST_DWithin(nodes.geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
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
      geom = query[:geom] || ((x = query[:x]) && (y = query[:y]) && Geo::factory.point(x.to_i, y.to_i))
      r = query[:r] || 0
    end
    chain = LandmarkDescription
    chain = chain.text_search(text) if text
    chain = chain.within_radius(geom, r) if geom
    chain.order('created_at DESC')
  end

  def tag_list
    landmark.tag_list
  end
end
