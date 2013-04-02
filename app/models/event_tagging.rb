class EventTagging < ActiveRecord::Base
  belongs_to :event_tag
  belongs_to :event
end
