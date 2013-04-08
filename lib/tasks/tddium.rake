# Copyright (c) 2011 Solano Labs All Rights Reserved
# lib/tasks/tddium.rake
namespace :tddium do
  desc 'default tddium environment db setup task'
  task :db_hook do
    Kernel.system 'cp config/social_services.yml.example config/social_services.yml'
    Rake::Task['db:create'].invoke
    Kernel.system "psql #{ENV['TDDIUM_DB_NAME']} -c 'CREATE EXTENSION hstore;'"
    Kernel.system "psql #{ENV['TDDIUM_DB_NAME']} -c 'CREATE EXTENSION postgis;'"
    Kernel.system "psql #{ENV['TDDIUM_DB_NAME']} -f db/sql/pgsnapshot_schema_0.6.sql"
    Kernel.system "echo 'drop table users;' | psql #{ENV['TDDIUM_DB_NAME']}"
    Rake::Task['db:migrate'].invoke
    Rake::Task['agc:functions'].invoke
  end
end