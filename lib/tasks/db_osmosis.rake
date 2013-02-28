namespace :db do
  desc 'Add Osmosis schema to the database'
  task osm_schema: :environment do
    config = Rails.configuration.database_configuration[Rails.env]
    #host     = config["host"]
    database = config['database']
    username = config['username']
    `psql #{database} --username=#{username} << EOF
        create extension hstore;
        create extension postgis;
EOF`
    puts 'hstore and postgis extensions created'
    `psql #{database} --username=#{username} < db/sql/pgsnapshot_schema_0.6.sql`
  end


  desc 'Drop table users from osmosis schema so it doesn\'t clash with our users table'
  task :osm_drop_users do
    config = Rails.configuration.database_configuration[Rails.env]
    database = config['database']
    username = config['username']
    puts "dropping table users"
    `psql #{database} --username=#{username} -c "drop table users;"`
  end


  require 'ptools'
  desc "Import OpenStreetMap data from an archive with Osmosis tool.
        Pass filename as parameter, both plain .osm and .osm.bz2 acceptable"
  task :osmosis, [:file] => :environment do |t, args|
    unless File.which "osmosis"
      puts "This task requires osmosis utility installed"
      next
    end
    args.with_defaults file: 'planet-latest.osm.bz2'
    puts "Importing file #{args[:file]}"
    unless File.exists? args[:file]
      puts "#{args[:file]} not found, please specify filename as parameter"
      next
    end
    config = Rails.configuration.database_configuration
    database = config[Rails.env]["database"]
    username = config[Rails.env]["username"]
    password = config[Rails.env]["password"]
    pwd_option = password && !password.empty? ? "password=#{password}" : ""
    `osmosis --read-xml #{args[:file]} --write-pgsql database=#{database} user=#{username} #{pwd_option}`
  end


  desc 'Prepare db schema, import osm data if file supplied'
  task :prepare, [:file] => :environment do |t, args|
    Rake::Task['db:osm_schema'].invoke
    Rake::Task['db:osmosis'].invoke args[:file] if args[:file]
    Rake::Task['db:osm_drop_users'].invoke
  end

  task :fill_with_test_data do
    Rake::Task['db:osmosis'].invoke 'RU-LEN.osm.bz2'
  end

  task :nuke do
    ['db:drop',
     'db:create',
     'db:osm_schema',
     'db:fill_with_test_data',
     'db:osm_drop_users',
     'db:migrate',
     'db:seed',
     'landmarks:populate'].each do |t|
      Rake::Task[t].invoke
    end
  end
end
