namespace :fake do

  desc "generate fake events"
  task events: :environment do
    load "#{Rails.root}/spec/support/blueprints.rb"
    events = YAML::load_file('spec/fixtures/events.yml')
    puts '----------------------------------------------------------------------'
    puts '-------------------------- CREATING EVENTS --------------------------'
    puts '----------------------------------------------------------------------'
    Agc.limit(3).each do |agc|
      3.times do 
        images = Array.new(3)
        images.map! { Image.make! image: File.open( pick_random_image(1024, 768) ) }
        e = Event.make! events.sample
        e.images = images
        e.agc = agc
        e.send [:start, :stop, :archive, :cancel].sample
        User.all.sample(Random.rand(5)).each { |u| u.vote_exclusively_for(e) }
        (0..Random.rand(5)).to_a.sample.times{ e.reviews << Review.make! }
        e.update_rating!
        e.save!
        puts "Event - #{e.id}"
      end
    end
  end
end
