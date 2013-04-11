
task process_event_states: :environment do
  sql = "start_date <= now() AND start_date >= now() - interval '1 day'"
  sql += " OR end_date <= now() AND end_date >= now() - interval '1 day'"
  sql += " OR archive_date <= now() AND archive_date >= now() - interval '1 day'"
  events = Event.where(sql)
  events.each do |e|
    begin
      e.update_state!
    rescue => ex
      Rails.logger.warn "#{ex.class}: #{ex.message}"
    end
  end
end
