
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

task update_events_rating: :environment do
  # 30 дней - максимальный срок сбора статистики
  # возможно надо будет выбирать более точнее
  # будем смотреть по реальным данным
  Event.where("end_date > '#{30.days.ago}'").all.each do |e|
    e.update_rating!
  end
end
