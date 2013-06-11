
namespace :fake do
  desc 'Generates fake runtips'
  task runtips: :users do
    load "#{Rails.root}/spec/support/blueprints.rb"
    load_routes
    
    puts '----------------------------------------------------------------------'
    puts '-------------------------- CREATING RUNTIPS --------------------------'
    puts '----------------------------------------------------------------------'
    GeoObject.last(5).each do |geo_object|
      5.times do
        user = User.last(5).sample
        Runtip.make! geo_object: geo_object, user: user
        puts "Building Runtip for GeoObject [#{geo_object_url(geo_object)}] on behalf of User [#{user.email}]"
      end
    end
  end

  task all: [:users, :runtips, :reviews, :comments, :votes]
end
