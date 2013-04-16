class LandmarkDescription < AbstractDescription

  attr_accessor :xld, :yld
  attr_accessible :xld, :yld, :rating, :geom

  acts_as_voteable

  def objects_nearby radius
    LandmarkDescription.where("abstract_descriptions.id <> #{id}").within_radius self.describable.osm.geom, radius
  end

  def self.within_radius geom, r
    LandmarkDescription.within_radius_scope geom, r, 'nodes'
  end

  def average_rating
    (rate = self.rating) > 0 ? rate.round : 0
  end

  def as_json options = nil
    op_hash = {
      only: [:id, :title, :body, :rating],
        methods: :tag_list,
        include: {
            describable: {
              only: [],
              include: :agc,
              include: {
                  osm: {
                     only: [],
                     methods: :latlon }}}}}
    op_hash[:only] = [:id, :title, :rating] if options[:extra][:teaser]
    super op_hash
 end

end
