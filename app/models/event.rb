class Event < ActiveRecord::Base
  include IceCube
  include PgSearch
  include Searchable
  attr_accessible :body, :title, :duration, :start_date, :repeat_rule, :landmark_id, :geom,
                  :images_attributes

  serialize                   :schedule, Hash
  set_rgeo_factory_for_column :geom,     Geo::factory

  belongs_to :user
  belongs_to :landmark
  has_many   :event_occurrences

  has_many :images,   as: :imageable
  accepts_nested_attributes_for :images

  validates :title, :start_date, :geom, presence: true
  validates_associated :user, :landmark

  after_create :event_after_create

  pg_search_scope :text_search,
                  against: {title: 'A', body: 'B'}

  scope :within_radius, ->(geom, r) do
    where "ST_DWithin(geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end

  scope :within_date_range, ->(from, to) do
    joins('JOIN event_occurrences ON event_occurrences.event_id = events.id').
        where "start_date >= '#{from}' AND start_date <= '#{to}'"
  end

  state_machine do

    before_transition on: :publish, do: :update_publish_date

    event :publish do
      transition to: :published
    end

    event :unpublish do
      transition from: :published, to: :not_published
    end

  end

  def update_publish_date
    self.published_at = Time.now
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
    self.event_occurrences.create! start_date: start_date
  end
end
