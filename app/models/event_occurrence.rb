class EventOccurrence < ActiveRecord::Base
  belongs_to :event
  attr_accessible :end_date, :start_date
  validates :start_date, presence: true

  def self.for_week any_day_of_week = Time.now
    monday = Chronic.parse('monday this week', now: any_day_of_week).strftime('%F')
    sunday = Chronic.parse('sunday this week', now: any_day_of_week).strftime('%F')
    EventOccurrence.where("start > DATE '#{monday}' AND start < DATE '#{sunday}'").order(:start)
  end

  state_machine initial: :new do

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

end
