class EventsController < InheritedResources::Base
  
  def new
    @landmarks = Landmark.limit(10)
    new!
  end

  def index
    if params[:week]
      @date = Time.parse(params[:week])
    else
      @date = Time.now
    end
    @event_occurrences = EventOccurrence.for_week 
    index!
  end
  
end
