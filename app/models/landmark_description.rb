class LandmarkDescription < Article
  belongs_to :landmark, :class_name => Geo::Landmark
end
