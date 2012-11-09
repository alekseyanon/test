class LandmarkDescription < Article
  belongs_to :landmark, :class_name => Geo::Landmark
  validates_associated :landmark
  accessible_attributes :landmark_id
end
