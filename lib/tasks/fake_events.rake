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
        images.map! { Image.make! image: File.open(pick_random_image) }
        e = Event.make! events.sample
        e.images = images 
        e.agc = agc
        e.save!
        puts "Event - #{e.id}"
      end
    end
  end
end
