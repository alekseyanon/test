class Api::EventsController < ApplicationController

  def week
    render text: 'ok'
  end

  def tags
    @tags = EventTag.all
    render json: @tags
  end

  def search
    query = {}
    query[:text] = params[:text] if params[:text]
    params[:from] = params[:to] = Time.now.strftime '%F' if params[:from].blank? or params[:to].blank?
    query[:from], query[:to] = ["#{params[:from]} 00:00:00", "#{params[:to]} 23:59:59"]
    @events = Event.search(query).page params[:page]
    render json: @events
  end

end
