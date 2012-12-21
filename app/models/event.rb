class Event < ActiveRecord::Base
  include IceCube
  serialize :schedule, Hash

  attr_accessible :body, :title, :duration, :start_date, :repeat_rule, :landmark_id, :image

  mount_uploader :image, ImageUploader

  belongs_to :user
  belongs_to :landmark
  has_many   :event_occurrences

  validates :title, :start_date, presence: true
  validates_associated :user, :landmark

  after_create :event_after_create

  def event_after_create
    if !self.repeat_rule.blank?
      self.create_schedule self.start_date, self.repeat_rule
      self.create_occurrences
    else
      self.create_occurrence self.start_date
    end
  end

  def create_schedule start_date, repeat_rule
    schedule = Schedule.new start_date
    case repeat_rule
    when 'daily'
      rule = Rule.daily
    when 'weekly'
      rule = Rule.weekly
    when 'monthly'
      rule = Rule.monthly
    when 'yearly'
      rule = Rule.yearly
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
    eo = EventOccurrence.new start: start_date
    eo.event = self
    eo.save!
  end

end
