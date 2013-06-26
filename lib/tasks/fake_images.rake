namespace :fake do

  desc 'Generate images for the first GoeObjects'
  task images: :environment do
    load "#{Rails.root}/spec/support/blueprints.rb"
    GeoObject.last(5).each do |go|
      puts "===========> GeoObject - #{go.id}"
      45.times do |i|
        img = File.open pick_random_image
        Image.make! imageable: go, image: img 
        puts "==> Image - #{i}"
      end
    end
  end
end
