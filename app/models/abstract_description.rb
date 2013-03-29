require 'set'

class AbstractDescription < ActiveRecord::Base

  extend FriendlyId
  friendly_id :make_slug, use: :slugged

  include PgSearch
  include Searchable
  has_many :reviews, as: :reviewable
  belongs_to :user
  belongs_to :describable, polymorphic: true
  attr_accessible :body, :describable, :published, :published_at, :title, :tag_list #TODO remove hack: accessible published, published_at
  validates :title, :user, presence: true
  validates_associated :user

  acts_as_taggable
  has_one :osm, through: :describable

  validates_associated :describable
  accessible_attributes :geo_unit_id #TODO remove hack: accessible geo_unit_id

  scope :within_radius_scope, ->(geom, r, table_name) do
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

  def bottom_categories
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
