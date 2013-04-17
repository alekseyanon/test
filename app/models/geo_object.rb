require 'set' # What is it?

class GeoObject < ActiveRecord::Base

  attr_accessor :xld, :yld
  attr_accessible :xld, :yld, :rating, :geom

  acts_as_voteable

  def objects_nearby radius
    GeoObject.where("abstract_descriptions.id <> #{id}").within_radius self.describable.osm.geom, radius
  end

  def self.within_radius geom, r
    GeoObject.within_radius_scope geom, r, 'nodes'
  end

  def average_rating
    (rate = self.rating) > 0 ? rate.round : 0
  end

  def as_json options = {}
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
    op_hash[:only] = [:id, :title, :rating] if options[:extra] && options[:extra][:teaser]
    super op_hash
 end

  extend FriendlyId
  friendly_id :make_slug, use: :slugged

  include PgSearch
  include Searchable
  has_many :reviews, as: :reviewable
  belongs_to :user
  attr_accessible :body, :describable, :published, :published_at, :title, :tag_list #TODO remove hack: accessible published, published_at
  validates :title, :user, presence: true
  validates_associated :user

  acts_as_taggable

  scope :within_radius_scope, ->(geom, r, table_name) do
    #joins("INNER JOIN geo_units ON abstract_descriptions.describable_id = geo_units.id
    #       INNER JOIN #{table_name} ON geo_units.osm_id = #{table_name}.id").
        where "ST_DWithin(abstract_descriptions.geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end

  scope :within_radius_for_area_scope, ->(geom, r, table_name) do
    joins("INNER JOIN geo_units ON abstract_descriptions.describable_id = geo_units.id
           INNER JOIN #{table_name} ON geo_units.osm_id = #{table_name}.id").
    where "ST_DWithin(#{table_name}.geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end

  pg_search_scope :text_search,
                  against: {title: 'A', body: 'B'},
                  associated_against: {tags: [:name]}

  before_validation :normalize_categories

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
