module Smorodina
  class Application
    config.assets.paths << File.join(config.root, 'vendor', 'assets', 'Leaflet', 'dist')
  end
end