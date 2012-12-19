class EventsController < InheritedResources::Base
  def new
    @landmarks = Landmark.limit(10)
    new!
  end
  def index
    @event_occurrences = EventOccurrence.for_week
    index!
  end
end
