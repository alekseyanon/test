class LandmarkDescription < Article
  belongs_to :landmark, :class_name => Geo::Landmark
  has_many :tags, through: :landmark
  has_one :node, through: :landmark

  validates_associated :landmark
  accessible_attributes :landmark_id

  pg_search_scope :text_search,
                  :against => {
                      title: 'A',
                      body: 'B'
                  }

  def self.search(query)
    query ?
        query.is_a?(Hash) ?
            query.has_key?(:geom) ?
                text_search(query[:text]).within_radius(query[:geom]) :
                text_search(query[:text]) :
            text_search(query) :
        all
  end
end
