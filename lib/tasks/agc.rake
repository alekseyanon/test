namespace :agc do

  require "#{Rails.root}/extras/rake_helper"

  desc 'Add geometry generation functions'
  task functions: :environment do
    RH.run_sql 'agc_generation_functions'
  end

  desc 'Generate relations geometries'
  task geoms: :environment do
    RH.run_sql 'generate_relations_geometries'
  end

  desc 'Generate AGCs'
  task gen: :environment do
    RH.run_sql 'generate_agcs'
  end

  desc 'Assign AGCs to geographical units'
  task assign: :environment do
    RH.run_sql 'assign_agcs'
  end

  desc 'Run all AGC tasks'
  task all: %w(agc:functions agc:geoms agc:gen agc:assign)
end
