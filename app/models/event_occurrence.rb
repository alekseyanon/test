class EventOccurrence < ActiveRecord::Base
  belongs_to :event
  attr_accessible :end, :start
  validates :start, presence: true

  def self.for_week any_day_of_week = Time.now
    monday = Chronic.parse('monday this week', now: any_day_of_week).strftime('%F')
    sunday = Chronic.parse('sunday this week', now: any_day_of_week).strftime('%F')
    EventOccurrence.includes(:event).where("start > DATE '#{monday}' AND start < DATE '#{sunday}'").order(:start)
  end

end
