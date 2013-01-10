class EventOccurrence < ActiveRecord::Base
  belongs_to :event
  attr_accessible :end, :start
  validates :start, presence: true

  def self.for_week any_day_of_week = Time.now
    monday = Chronic.parse 'monday this week', now: any_day_of_week
    sunday = Chronic.parse 'sunday this week', now: any_day_of_week
    EventOccurrence.where("start > '#{monday}' AND start < '#{sunday}'").order(:start)
  end

end
