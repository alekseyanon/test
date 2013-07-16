every 1.day do
  rake 'process_event_states'
end

every 1.hour do
  rake 'update_users_ratings'
end
