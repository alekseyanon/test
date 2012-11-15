require 'ptools'

desc "Importing OpenStreetMap data from an archive with Osmosis tool.
      Pass filename as parameter, both plain .osm and .osm.bz2 acceptable"
task :osmosis, [:file] => :environment do |t, args|
  unless File.which "osmosis"
    puts "This task requires osmosis utility installed"
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
  password = config[Rails.env]["password"]
  #`osmosis -s -d #{database} -U #{username} #{args[:file]}` #--keep-coastlines
  #`createdb --owner=#{username} --username=postgres #{database}`
  `psql #{database} --username=#{username} << EOF
      create extension hstore;
      create extension postgis;
EOF`
  puts "----------------------------------------------"
  `psql #{database} --username=#{username} < /usr/share/java/osmosis/script/pgsnapshot_schema_0.6.sql`
  pwd_option = password && !password.empty? ? "password=#{password}" : ""
  `osmosis --read-xml #{args[:file]} --write-pgsql database=#{database} user=#{username} #{pwd_option}`
end