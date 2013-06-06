
class Routes 
  include Rails.application.routes.url_helpers
end

Routes.default_url_options[:host] = "localhost:3000"
r = Routes.new

namespace :fake do
  desc 'Generates fake reviews for GeoObject and User'
  task reviews: :users do
    load "#{Rails.root}/spec/support/blueprints.rb"

    puts '----------------------------------------------------------------------'
    puts '-------------------------- CREATING REVIEWS --------------------------'
    puts '----------------------------------------------------------------------'
    GeoObject.last(5).each do |reviewable|
      user = User.last(5).sample
      5.times do
        review          = Review.make! reviewable: reviewable, user: user
        link_review     = r.review_url(review)
        link_reviewable = r.geo_object_url(reviewable)
        puts "Building Review #{link_review} for #{reviewable.class} #{link_reviewable}"
      end
    end
  end
end
