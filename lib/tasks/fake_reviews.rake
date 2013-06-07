
namespace :fake do
  desc 'Generates fake reviews for GeoObject and User'
  task reviews: :users do
    load "#{Rails.root}/spec/support/blueprints.rb"
    load_routes

    puts '----------------------------------------------------------------------'
    puts '-------------------------- CREATING REVIEWS --------------------------'
    puts '----------------------------------------------------------------------'
    GeoObject.last(5).each do |reviewable|
      user = User.last(5).sample
      5.times do
        review          = Review.make! reviewable: reviewable, user: user
        link_review     = review_url(review)
        link_reviewable = geo_object_url(reviewable)
        puts "Building Review [#{link_review}] for GeoObject [#{link_reviewable}] on behalf of User [#{user.email}]"
      end
    end
  end
end
