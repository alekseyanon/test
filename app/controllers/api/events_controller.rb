class Api::EventsController < ApplicationController
  respond_to :json

  def week
    @events = Event.for_7_days_from(Time.parse(params[:date]) || Time.now)
    respond_with(@events, include: :images)
  end

  def tags
    @tags = EventTag.all
    render json: @tags
  end

  def search
    query = {}
    query[:text] = params[:text] if params[:text]
    query[:from], query[:to] = ["#{params[:from]} 00:00:00", "#{params[:to]} 23:59:59"] if params[:from] and params[:to]
    @events = Event.scoped
    @events = @events.search(query) if not query.blank?
    @events = @events.includes(:event_tags).where('event_tags.id' => params[:tag_id]) if params[:tag_id]
    @events = @events.page params[:page]
    render json: @events
  end

end
