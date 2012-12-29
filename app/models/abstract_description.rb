require 'set'

class AbstractDescription < ActiveRecord::Base
  include PgSearch
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

  # Searches descriptions against title, body, tags.
  # For queries with geospatial part, search is done within a radius of some point.
  #
  # @param [String, Hash] query 'query string' or {text: 'query string', geom: RGeo::Feature::Point, r: radius}
  #     or {text: 'query string', x: latitude, y: longitude, r: radius}
  # @return ActiveRecord::Relation all matching descriptions
  def self.search(query)
    return all unless query && !query.empty?
    chain = self
    if query.is_a? String
      text = query
    else
      query = query.delete_if { |k, v| v.nil? || (v.respond_to?(:empty?) && v.empty?) }
      chain = chain.tagged_with query[:facets], any: true  if query[:facets]
      geom = query[:geom] || ((y = query[:x]) && (x = query[:y]) && Geo::factory.point(x.to_f, y.to_f)) #TODO mind x y
      r = query[:r] || 0
      chain = chain.within_radius(geom, r) if geom
      text = query[:text]
    end
    chain = chain.text_search text if text && !text.empty?
    chain.where("abstract_descriptions.title != 'NoName'").limit 20
  end

  before_validation :normalize_categories

  def categories_tree(parent = Category.root, filter = Category.where(name: tag_list).to_set)
    tree = parent.children.reduce({}) do |memo,c|
      memo[c.name_ru] = categories_tree(c,filter) if filter.include? c
      memo
    end
    tree.empty? ? nil : tree
  end

  protected
  def normalize_categories
    self.tag_list = Category.where(name: tag_list).map(&:self_and_ancestors).flatten.map(&:name).compact.uniq
  end
end
