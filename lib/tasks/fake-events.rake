namespace :fake do

  desc "generate fake events"
  task :events => :environment do
    load "#{Rails.root}/spec/support/blueprints.rb"
    fg = FakeGenerator.new
    fg.create_events
  end

end

class FakeGenerator
  def initialize
    @image_dir = File.join Rails.root, 'spec/fixtures/images/fishing'
    @events = YAML::load_file('spec/fixtures/events.yml')
    @images = load_files @image_dir
  end

  def create_events
    @images.each do |image|
      e = Event.make! @events.sample
      e.image.store! File.open File.join(@image_dir, image)
      e.save!
    end
  end

  def load_files dir
    Dir.entries(dir).reject{|entry| entry == "." || entry == ".."}
  end


end
