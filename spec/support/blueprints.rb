# fun coding: UTF-8
require 'machinist/active_record'

Osm::Node.blueprint do
  id { 2 * 10 ** 9 + 9000 + sn.to_i }
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
  user { User.make! }
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
  pwd = Faker::Lorem.characters(9)
  password { pwd }
  password_confirmation { pwd }
  email { Faker::Internet.email }
  #roles { ["traveler"] }
  profile { Profile.make! }
end

Event.blueprint do
  title { Faker::Lorem.sentence }
  start_date { (1..14).to_a.sample.days.ago }
  geom { Geo::factory.point(10, 10) }
  duration {3}
end

EventOccurrence.blueprint do
  start { Time.now }
end

Review.blueprint do
  title { Faker::Lorem.sentence }
  body { Faker::Lorem.sentences 10 }
  user { User.make! }
  reviewable { LandmarkDescription.make! }
end

Image.blueprint do
  # Attributes here
end

Comment.blueprint do
  body { Faker::Lorem.sentences 3 }
  user { User.make! }
  commentable { Review.make! }
end

Profile.blueprint do
  name { Faker::Lorem.word }
end

Rating.blueprint do
  user { User.make! }
  value { rand(1..5) }
  landmark_description { LandmarkDescription.make! }
end

