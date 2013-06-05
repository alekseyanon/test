
namespace :fake do
  desc 'Generates fake reviews for GeoObject and User'
  task reviews: :environment do
    load "#{Rails.root}/spec/support/blueprints.rb"
    
    [GeoObject, User].each do |parent|
      3.times do
        parent_obj = parent.make!
        5.times do
          r = Review.make! reviewable: parent_obj
          puts "Building Review #{r.id} for #{parent} #{parent_obj.id}"
        end
      end
    end
  end
end
