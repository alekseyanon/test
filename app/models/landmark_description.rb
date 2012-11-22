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

  def self.search(query)
    return all unless query && !query.empty?
    if query.is_a? String
      text = query
    else
      query = query.delete_if { |k, v| v.nil? || v.empty? }
      text = query[:text]
      geom = query[:geom] || ((x = query[:x]) && (y = query[:y]) && Geo::factory.point(x.to_i, y.to_i))
      r = query[:r] || 0
    end
    chain = LandmarkDescription
    chain = chain.text_search(text) if text
    chain = chain.within_radius(geom, r) if geom
    chain.order('created_at DESC')
  end
end
