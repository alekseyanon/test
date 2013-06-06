require 'set' # What is it?

class GeoObject < ActiveRecord::Base

  attr_accessor :xld, :yld, :best_object
  attr_accessible :xld, :yld, :rating, :images_attributes, :geom

  scope :ordered_by_rating, order('rating DESC, created_at DESC')
  scope :ordered_by_name,   order('title')

  acts_as_voteable

  def objects_nearby radius
    GeoObject.where("geo_objects.id <> #{id}").within_radius self.geom, radius
  end

  def average_rating
    (rate = self.rating) > 0 ? rate.round : 0
  end

  def latlon
    [geom.y, geom.x] #TODO figure out what's really latitude and what is longitude
  end
  
  def agc_titles
    self.agc.titles
  end
  
  def as_json options = {}
    op_hash = { only: [:id, :title, :body, :rating, :geom, :slug], methods: [:tag_list, :latlon, :best_object, :agc_titles, :average_rating], include: [:agc, :images] }
    op_hash[:only] = [:id, :title, :rating] if options[:extra] && options[:extra][:teaser]
    super op_hash
  end

  extend FriendlyId
  friendly_id :make_slug, use: :slugged

  include PgSearch
  include Searchable
  has_many :reviews,    as: :reviewable
  has_many :images,     as: :imageable
  has_many :runtips
  has_many :complaints, as: :complaintable

  accepts_nested_attributes_for :images

  belongs_to :user
  belongs_to :agc
  attr_accessible :body, :published, :published_at, :title, :tag_list #TODO remove hack: accessible published, published_at
  validates :title, :user, presence: true
  validates_associated :user  

  #TODO consider refactoring: move from here and from event.rb to a separate module
  has_many   :video_links, as: :movie_star
  has_many   :you_tubes, through: :video_links, uniq: true, source: :video, source_type: 'YouTube'
  has_many   :vimeos,    through: :video_links, uniq: true, source: :video, source_type: 'Vimeo'

  acts_as_taggable

  pg_search_scope :text_search,
                  against: {title: 'A', body: 'B'},
                  associated_against: {tags: [:name]}

  before_validation :normalize_categories

  scope :with_agc, ->(id) { where agc_id: id }

  def categories_tree(parent = Category.root, filter = Category.where(name: tag_list).to_set)
    tree = parent.children.reduce({}) do |memo,c|
      memo[c.name_ru] = categories_tree(c,filter) if filter.include? c
      memo
    end
    tree.empty? ? nil : tree
  end

  def leaf_categories
    Category.where(name: tag_list).leaves.pluck(:name).uniq
  end

  def should_generate_new_friendly_id?
    new_record?
  end

  private

  def make_slug
    "#{title ? title : 'place-travel'}"
  end

  protected
  def normalize_categories
    self.tag_list = Category.where(name: tag_list).map(&:self_and_ancestors).flatten.map(&:name).compact.uniq
  end

end
