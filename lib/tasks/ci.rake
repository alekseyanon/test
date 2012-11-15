desc 'Top task for continuous integration server'

task "db:import"  do
  task(:osmosis).invoke("#{ENV["HOME"]}/osm/RU-IRK.osm.bz2")
end

task :ci => %w(db:configure db:drop db:create db:import db:migrate spec)


