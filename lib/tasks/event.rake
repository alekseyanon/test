
task process_event_states: :environment do
  Event.process_states
end

task update_events_rating: :environment do
  Event.update_rating
end
