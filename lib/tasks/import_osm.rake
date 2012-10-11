require 'ptools'

desc "Importing OpenStreetMap data from an archive.
      Pass filename as parameter, both plain .osm and .osm.bz2 acceptable"
task :import_osm, [:file] => :environment do |t, args|
  unless File.which "osm2pgsql"
    puts "This task requires osm2pgsql utility installed"
    next
  end
  args.with_defaults(:file => "planet-latest.osm.bz2")
  puts args[:file]
  unless File.exists? args[:file]
    puts "#{args[:file]} not found, please specify filename as parameter"
    next
  end
  config   = Rails.configuration.database_configuration
  #host     = config[Rails.env]["host"]
  database = config[Rails.env]["database"]
  username = config[Rails.env]["username"]
  ENV['PGPASS'] = password = config[Rails.env]["password"]
  `osm2pgsql -s -d #{database} -U #{username} #{args[:file]}` #--keep-coastlines
end