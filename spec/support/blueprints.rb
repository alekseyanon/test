# fun coding: UTF-8
require 'machinist/active_record'

Osm::Node.blueprint do
  id { 2 * 10 ** 9 + 2000 + sn.to_i }
  geom { Geo::factory.point(29.9918672, 60.0052767) }
  tags { { transport: 'subway', station: 'subway',
           railway: 'station', operator: 'Петербургский метрополитен',
           :'name:ru' => 'Рыбацкое', :'name:fi' => 'Rybatškoje',
           :'name:en' => 'Rybatskoye', :'name:de' => 'Rybazkoje',
           name: 'Рыбацкое',
           colour: 'green' } }
  version { 0 }
  user_id { 0 }
  tstamp { Time.now }
  changeset_id { 0 }
end

Osm::Poly.blueprint do
  id { 2 * 10 ** 6 + sn.to_i }
  tags { { name: "ТД \"Карел Камень\" причал \"Обухово\"", landuse: "industrial"} }
  nodes { [2003736032,2003736029,2003736036,2003736028,2003736030,2003736034,2003736026,28975413,2003736033,2003736032] }
  version { 0 }
  user_id { 0 }
  tstamp { Time.now }
  geom { Geo.factory.polygon Geo.factory.line_string [[0,0], [1,0], [0,1], [0,0]].map{|(x,y)| Geo.factory.point x,y } }
  changeset_id { 0 }
end

Landmark.blueprint do
  osm { Osm::Node.make }
end

Area.blueprint do
  osm { Osm::Poly.make }
end

Category.blueprint do
  name { Faker::Lorem.word }
  name_ru { Faker::Lorem.word }
  description { Faker::Lorem.sentence 2 }
end

AbstractDescription.blueprint do
  user { User.make }
  title { Faker::Lorem.sentence }
  body { Faker::Lorem.sentences 10 }
  published { [true, false].sample }
  published_at { Time.now }
end

LandmarkDescription.blueprint do
  describable { Landmark.make }
end

AreaDescription.blueprint do
  describable { Area.make }
end

Authentication.blueprint do
  # Attributes here
end

User.blueprint do
  tmp = Faker::Lorem.characters(5)
  name { Faker::Lorem.word }
  password { tmp }
  password_confirmation { tmp }
  email { Faker::Internet.email }
  roles { ["traveler"] }
  perishable_token { "perishabletoken" }
end

Event.blueprint do
  title { Faker::Lorem.sentence }
  start_date { Time.now }
  duration {3}
  repeat_rule { 'weekly' }
end

EventOccurrence.blueprint do
  # Attributes here
end
