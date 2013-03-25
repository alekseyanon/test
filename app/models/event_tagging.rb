class EventTagging < ActiveRecord::Base
  belongs_to :event_tag
  belongs_to :event
  # attr_accessible :title, :body
end
