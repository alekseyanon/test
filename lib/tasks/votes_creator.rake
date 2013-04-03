def generate_users(count)
  if (c = User.all.count) <= count
    puts 'make new users:'
    require pp
    load "#{Rails.root}/spec/support/blueprints.rb"
    (count - c + 1).times do |i|
      pp i
      User.make!
    end
  end
  @users = User.first(count)
end

namespace :votes do
  desc 'Generate votes for some landmark descriptions'
  task creator: :environment do

    puts 'rake task started'
    user_count = 10
    puts 'set users count'
    @landmarkdescriptions = LandmarkDescription.first(4)
    puts 'select needed landmark descriptions'
    generate_users(user_count)
    puts 'generate users'
    @landmarkdescriptions.each do |ld|
      puts "=> #{ld.title} - #{ld.id}"
      p = rand(user_count)
      p.times do |i|
        puts "====> up vote user - #{i}"
        ld.leaf_categories.each {|tag| @users[i].vote_exclusively_for(ld, tag)}
      end
      (p).upto(user_count - 1) do |i|
        puts "====> down vote user - #{i}"
        ld.leaf_categories.each {|tag| @users[i].vote_exclusively_against(ld, tag)}
      end
    end
  end
end
