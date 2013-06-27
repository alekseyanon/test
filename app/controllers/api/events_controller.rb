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
    @events = Event.filtered_search(search_params).page params[:page]
    render json: @events
  end

  def autocomplete
    @events = Event.autocomplete search_params
    render formats: :json
  end

  private
  def search_params
    params.permit *Event::ALLOWED_SEARCH_PARAMS
  end
end
