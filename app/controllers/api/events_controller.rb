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
    query = prepare_search_query
    @events = Event.scoped
    @events = @events.search(query) unless query.blank?
    @events = @events.include_tags(params[:tag_id]).order_by(params[:sort_by]).page params[:page]
    render json: @events
  end

  def autocomplete
    params[:limit] ||= Event::AUTOCOMPLETE_LIMIT
    query = prepare_search_query
    @events = Event.scoped
    @events = @events.search(query) unless query.blank?
    @events = @events.autocomplete_search(params[:term]).limit(params[:limit])
    render formats: :json
  end

  private

    def prepare_search_query
      query = Hash.new
      query[:text] = params[:text]
      query[:place_id] = params[:place_id]
      if params[:from] && params[:to]
        query[:from], query[:to] = ["#{params[:from]} 00:00:00", "#{params[:to]} 23:59:59"]
      elsif params[:from]
        query[:from] = "#{params[:from]} 00:00:00"
      elsif params[:place_id] && Event.in_place(params[:place_id]).future.count > 0
        query[:from] = Time.now
      end
      query
    end

end
