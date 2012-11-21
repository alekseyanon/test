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
    query ?
        query.is_a?(Hash) ?
            query.has_key?(:geom) ?
                text_search(query[:text]).within_radius(query[:geom], query[:radius]) :
                text_search(query[:text]) :
            text_search(query) :
        all
  end
end
