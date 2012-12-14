# Copyright (c) 2011 Solano Labs All Rights Reserved
# lib/tasks/tddium.rake
namespace :tddium do
  desc "default tddium environment db setup task"
  task :db_hook do
    Rake::Task["db:create"].invoke
    Kernel.system("psql #{ENV['TDDIUM_DB_NAME']} -c 'CREATE EXTENSION hstore;'")
    Kernel.system("psql #{ENV['TDDIUM_DB_NAME']} -f db/sql/pgsnapshot_schema_0.6.sql")
    Kernel.system("echo 'drop table users;' | psql #{ENV['TDDIUM_DB_NAME']}")
    Rake::Task['db:migrate'].invoke
  end
end