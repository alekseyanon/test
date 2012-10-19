require 'machinist/active_record'

Geo::Osm::Node.blueprint do
  id { 2 * 10 ** 9 + sn.to_i }
  lat { 10 }
  lon { 20 }
  tags { { transport: 'subway', station: 'subway',
           railway: 'station', operator: 'Петербургский метрополитен',
           :'name:ru' => 'Рыбацкое', :'name:fi' => Rybatškoje,
           :'name:en' => 'Rybatskoye', :'name:de' => 'Rybazkoje',
           name: 'Рыбацкое',
           colour: 'green' } }
end

Geo::Landmark.blueprint do
  id { sn }
  name { Faker::Lorem.word }
  node { Geo::Osm::Node.make }
end
