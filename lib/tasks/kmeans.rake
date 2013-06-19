require "#{Rails.root}/extras/rake_helper"

desc 'Add geometry generation functions'
task kmeans: :environment do
  RH.run_sql 'kmeans'
end
