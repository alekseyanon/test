task update_users_ratings: :environment do
  User.find_each { |user| user.update_rating }
end
