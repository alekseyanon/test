class EventsController < InheritedResources::Base

  def new
    @landmarks = Landmark.limit(10)
    new!
  end

  def index
    @event_occurrences = EventOccurrence.for_week
    @days = {}
    day = nil
    @event_occurrences.each do |eo|
      if eo.start.strftime("%F") != day
        day = eo.start.strftime("%F")
        @days[day] = []
      end
      @days[day] << eo
    end
    index!
  end

end
