class Event < ActiveRecord::Base
  include IceCube
  include PgSearch
  include Searchable
  attr_accessible :body, :title, :duration, :start_date, :repeat_rule, :landmark_id, :geom,
                  :images_attributes, :event_tags, :tag_list#, :system_event_tag_id

  serialize                   :schedule, Hash
  set_rgeo_factory_for_column :geom,     Geo::factory

  belongs_to :user
  belongs_to :landmark
  has_many   :event_taggings
  has_many   :event_occurrences
  has_many   :event_tags, through: :event_taggings
  has_many   :images,   as: :imageable

  accepts_nested_attributes_for :images

  validates :title, :start_date, :geom, presence: true
  validate  :validate_event_tags
  validates_associated :user, :landmark


  def validate_event_tags
    errors.add(:event_tags, "need at least 1 tag") if event_tags.length < 1
  end

  after_create :event_after_create

  pg_search_scope :text_search,
                  against: {title: 'A', body: 'B'}

  scope :within_radius, ->(geom, r) do
    where "ST_DWithin(geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end

  scope :within_date_range, ->(from, to) do
    joins('JOIN event_occurrences ON event_occurrences.event_id = events.id').
        where "start >= '#{from}' AND start <= '#{to}'"
  end

  def event_after_create
    if self.repeat_rule.blank?
      self.create_occurrence self.start_date
    else
      self.create_schedule self.start_date, self.repeat_rule
      self.create_occurrences
    end
  end

  def create_schedule start_date, repeat_rule
    schedule = Schedule.new start_date
    rule = case repeat_rule
    when 'daily'
      Rule.daily
    when 'weekly'
      Rule.weekly
    when 'monthly'
      Rule.monthly
    when 'yearly'
      Rule.yearly
    when 'half-year'
      Rule.monthly(6)
    else
      raise "Unknown repeat rule: #{repeat_rule}"
    end
    schedule.add_recurrence_rule rule
    self.schedule=schedule
    schedule
  end

  def schedule=(schedule)
    write_attribute(:schedule, schedule.to_hash)
  end

  def schedule
    Schedule.from_hash(read_attribute(:schedule))
  end

  def create_occurrences
    self.schedule.first(10).each do |datetime|
      create_occurrence datetime
    end
  end

  def create_occurrence start_date
    self.event_occurrences.create! start: start_date
  end

  def tag_list
    event_tags.map(&:title).join(", ")
  end

  def tag_list=(names)
    self.event_tags = names.split(",").map do |n|
      EventTag.where(title: n.strip).first_or_create!
    end
  end

end
