class EventOccurrence < ActiveRecord::Base
  belongs_to :event
  attr_accessible :end, :start
end
