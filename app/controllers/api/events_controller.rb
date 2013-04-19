class Api::EventsController < ApplicationController
  respond_to :json

  def week
    @events = Event.for_7_days_from(Time.parse(params[:date]) || Time.now).newest
    respond_with(@events, include: :images)
  end

  def tags
    @tags = EventTag.all
    render json: @tags
  end

  def search
    place_id = params[:place_id]
    query = {}
    query[:text] = params[:text]
    query[:place_id] = place_id
    if params[:from] && params[:to]
      query[:from], query[:to] = ["#{params[:from]} 00:00:00", "#{params[:to]} 23:59:59"]
    elsif params[:from]
      query[:from] = "#{params[:from]} 00:00:00"
    elsif place_id
      query[:from] = Time.now if Event.in_place(place_id).where("start_date > '#{Time.now}'").count > 0
    end
    @events = Event.scoped
    @events = @events.search(query) unless query.blank?
    @events = @events.includes(:event_tags).where('event_tags.id' => params[:tag_id]) if params[:tag_id]
    @events = @events.page params[:page]
    render json: @events
  end

end
