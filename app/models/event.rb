class Event < ActiveRecord::Base
  include IceCube
  include PgSearch
  include Searchable
  require 'digest/sha2'

  REPEAT_RULES = ['weekly', 'monthly', 'quarterly', 'half-year', 'yearly', 'two-years', 'three-years', 'four-years']

  attr_accessible :body, :title, :start_date, :end_date,
                  :repeat_rule, :geom,
                  :images_attributes, :event_tags, :tag_list

  before_create :generate_key

  # TODO delete EO table
  # TODO gen event line key
  # TODO validate event duration
  # TODO validate event repeat rule
  # TODO рассчитывать дату архивации сразу
  # TODO написать таску для прогона событий по состояниям

  serialize :schedule, Hash
  set_rgeo_factory_for_column :geom, Geo::factory

  belongs_to :user
  has_many   :event_taggings
  has_many   :event_tags, through: :event_taggings
  has_many   :images,   as: :imageable

  accepts_nested_attributes_for :images

  validates :title, :start_date, :geom, presence: true
  validate  :validate_event_tags
  validate  :validate_event_duration
  validates_associated :user

  def validate_event_duration
    # TODO
    1 if repeat_rule
  end


  def validate_event_tags
    errors.add(:event_tags, "need at least 1 tag") if event_tags.length < 1
  end

  pg_search_scope :text_search,
                  against: {title: 'A', body: 'B'}

  scope :within_radius, ->(geom, r) do
    where "ST_DWithin(geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end

  scope :within_date_range, ->(from, to) do
    where "start_date >= '#{from}' AND start_date <= '#{to}'"
  end

  # TODO Конец всему/Горшочек не вари
  state_machine initial: :new do

    after_transition on: :archive, do: :create_new_repeat_event

    event :start do
      transition from: :new, to: :started
    end

    event :end do
      transition from: :started, to: :ended
    end

    event :archive do
      transition from: :ended, to: :archived
    end

    event :cancel do
      transition to: :canceled
    end

  end

  def create_new_repeat_event
    unless repeat_rule.blank?
      puts 'I create next event in this line'
    end
  end

  def generate_key
    # TODO проверять уникальность, генерировать только для повторяющихся
    key = Digest::SHA2.hexdigest title+start_date.to_s if key.blank?
  end

  def duration
    if end_date
      (end_date - start_date).to_i / 1.day
    else
      0
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

  def tag_list
    event_tags.map(&:title).join(", ")
  end

  def tag_list=(names)
    self.event_tags = names.split(",").map do |n|
      EventTag.where(title: n.strip).first_or_create!
    end
  end

  private

    def next_start_date
      # TODO
    end

end
