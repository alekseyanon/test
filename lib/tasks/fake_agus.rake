# -*- encoding : utf-8 -*-

namespace :fake do
  desc 'Generates fake agus to make location determining on map work'
  task agus: :environment do
    
    # TODO: Create .yaml file the data
    AGUS = {  'Братск' =>     [56.158553, 101.57135],
              'Киев'   =>     [50.450509, 30.539246],
              'Ярославль' =>  [57.642461, 39.884491],
              'Красноярск' => [56.016424, 92.851639],
              'Санкт-Петербург' => [59.945383, 30.307159],
              'Москва'          => [55.749531, 37.622681]
           }

    DELTA = 0.01
    
    AGUS.each do |city, coords|
      puts "Creating city #{city}"
      Agu.create title: city, geom: "POLYGON((#{coords[0]} #{coords[1]},
                                              #{coords[0] + DELTA} #{coords[1]},
                                              #{coords[0] + DELTA} #{coords[1] + DELTA},
                                              #{coords[0]} #{coords[1] + DELTA},
                                              #{coords[0]} #{coords[1]} ))"
    end

  end
end
