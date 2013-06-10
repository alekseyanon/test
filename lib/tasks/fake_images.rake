namespace :fake do
  desc 'Generate images for the first GoeObjects'
  task images: :environment do
    load "#{Rails.root}/spec/support/blueprints.rb"
    GeoObject.first(5).each do |go|
      puts "===========> GeoObject - #{go.id}"
      45.times do |i|
        Image.make!(imageable: go)
        puts "==> Image - #{i}"
      end
    end
  end
end
