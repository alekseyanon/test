namespace :fake do
  desc 'Generate images for the first GoeObjects'

  PLACEHOLDERS_FOLDER = Rails.root.join('public', 'placeholders', 'objects')

  task images: :environment do
    load "#{Rails.root}/spec/support/blueprints.rb"
    GeoObject.last(5).each do |go|
      puts "===========> GeoObject - #{go.id}"
      45.times do |i|
        img = File.open pick_random_image( 'objects' )
        Image.make! imageable: go, image: img rescue puts( 'Oops' )
        puts "==> Image - #{i}"
      end
    end
  end
end
