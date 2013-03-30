class EventsController < InheritedResources::Base
  respond_to :html, except: :search
  respond_to :json, only: :search

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
    #respond_with(@event_occurrences, include: :event)
  end

  # event[tag_list] - пользовательские теги через запятую
  # system_event_tag_id - id одного из системных тегов
  def create
    params[:event][:start_date] = Time.parse params[:event][:start_date]
    @event = Event.new params[:event]
    unless params[:system_event_tag_id].blank?
      system_tag = EventTag.find params[:system_event_tag_id]
      @event.event_tags << system_tag
    end
    create!
  end

end
