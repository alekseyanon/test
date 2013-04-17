def generate_users(count)
  if (c = User.all.count) <= count
    puts 'make new users:'
    load "#{Rails.root}/spec/support/blueprints.rb"
    (count - c + 1).times do |i|
      print i.to_s
      User.make!
    end
  end
  @users = User.first(count)
end

namespace :fake do
  desc 'Generate votes for some landmark descriptions'
  task votes: :environment do

    puts 'rake task started'
    user_count = 10
    puts 'set users count'
    @landmarkdescriptions = LandmarkDescription.first(20)
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
      ld.update_attributes(rating: (ld.plusminus.to_f / ld.leaf_categories.count.to_f))
    end
  end
end