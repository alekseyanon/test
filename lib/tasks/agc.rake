namespace :agc do

  def database; Rails.configuration.database_configuration[Rails.env]['database'] end
  def username; Rails.configuration.database_configuration[Rails.env]['username'] end

  def run_script(name)
    `psql #{database} --username=#{username} < db/sql/#{name}.sql`
  end

  desc 'Add geometry generation functions'
  task functions: :environment do
    run_script 'agc_generation_functions'
  end

  desc 'Generate relations geometries'
  task geoms: :environment do
    run_script 'generate_relations_geometries'
  end

  desc 'Generate AGCs'
  task gen: :environment do
    run_script 'generate_agcs'
  end

  desc 'Assign AGCs to geographical units'
  task geoms: :environment do
    run_script '' #TODO
  end
end
