
namespace :fake do
  desc 'Generates fake runtips'
  task runtips: :environment do
    load "#{Rails.root}/spec/support/blueprints.rb"
    
    GeoObject.first(5).each do |o|
      3.times do
        r = Runtip.make! geo_object: o
        puts "Building Runtip #{r.id} for GeoObject #{o.id}"
      end
    end
  end
end
