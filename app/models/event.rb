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

end