class EventsController < InheritedResources::Base
  load_and_authorize_resource only: CRUD_ACTIONS

  respond_to :html, except: :search
  respond_to :json, only: :search

  before_filter :load_youtube #TODO remove hack, consider moving to initializers
  def load_youtube
    Video
    YouTube
  end

  def new
    new!
  end

  def index
    if params[:week]
      @date = Time.parse(params[:week])
    else
      @date = Time.now
    end
  end

  # event[tag_list] - пользовательские теги через запятую
  # system_event_tag_id - id одного из системных тегов
  def create
    params[:event][:start_date] = Time.parse params[:event][:start_date]
    @event = current_user.events.build(params[:event])
    unless params[:system_event_tag_id].blank?
      system_tag = EventTag.find params[:system_event_tag_id]
      @event.event_tags << system_tag
    end
    if create! && params[:video_urls]
      video_urls = params[:video_urls].values
      video_urls.each do |url|
        VideoLink.find_or_create_by_content current_user, @event, url
      end
    end
  end

  def update
    @event = current_resource
    update!
  end

  def edit
    @event = current_resource
    edit!
  end

  private

  def current_resource
    @current_resource ||= Event.find(params[:id]) if params[:id]
  end

end
