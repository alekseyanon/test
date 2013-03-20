class EventsController < InheritedResources::Base
  respond_to :html#, except: :index
  respond_to :json, only: :index

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
    @event_occurrences = EventOccurrence.for_week @date
    @days = {}
    day = nil
    @event_occurrences.each do |eo|
      if eo.start.strftime("%F") != day
        day = eo.start.strftime("%F")
        @days[day] = []
      end
      @days[day] << eo
    end
    respond_with(@event_occurrences, include: :event)
  end

  def create
    params[:event][:start_date] = Time.parse params[:event][:start_date]
    create!
  end

  def search
    query = {}
    query[:text] = params[:text] if params[:text]
    if !params[:date].blank?
      query[:date] = ["#{params[:date]} 00:00:00", "#{params[:date]} 23:59:59"]
    end
    @events = Event.search query if !query.blank?
  end

end
