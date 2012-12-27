module EventsHelper

  def week_path week, date
    next_week = Chronic.parse(week, :now => date).strftime "%F"
    events_path+"?week=#{next_week}"
  end

end