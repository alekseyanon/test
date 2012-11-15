desc 'Top task for continuous integration server'

task :parametrized do
  task("db:configure").invoke ENV["USER"], 'HyY%z\(bK'
  task("db:drop").invoke
  task("db:create").invoke
  task(:osmosis).invoke("#{ENV["HOME"]}/osm/RU-IRK.osm.bz2")
end

task :ci => %w(parametrized db:migrate spec)


