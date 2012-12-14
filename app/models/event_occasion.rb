class EventOccasion < ActiveRecord::Base
  belongs_to :event
  attr_accessible :end, :start
end
