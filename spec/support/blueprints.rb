# fun coding: UTF-8
require 'machinist/active_record'

Geo::Osm::Node.blueprint do
  id { 2 * 10 ** 9 + 1000 + sn.to_i }
  lat { 10 }
  lon { 20 }
  tags { { transport: 'subway', station: 'subway',
           railway: 'station', operator: 'Петербургский метрополитен',
           :'name:ru' => 'Рыбацкое', :'name:fi' => 'Rybatškoje',
           :'name:en' => 'Rybatskoye', :'name:de' => 'Rybazkoje',
           name: 'Рыбацкое',
           colour: 'green' } }
end

Geo::Landmark.blueprint do
  name { Faker::Lorem.word }
  node { Geo::Osm::Node.make }
end

Category.blueprint do
  name { Faker::Lorem.word }
  description { Faker::Lorem.sentence 2 }
end

Article.blueprint do
  user { User.make }
  title { Faker::Lorem.sentence }
  body { Faker::Lorem.sentences 10 }
  published { [true, false].sample }
  published_at { Time.now }
end

LandmarkDescription.blueprint do
  user { User.make }
  title { Faker::Lorem.sentence }
  body { Faker::Lorem.sentences 10 }
  published { [true, false].sample }
  published_at { Time.now }

  landmark { Geo::Landmark.make }
end

Authentication.blueprint do
  # Attributes here
end

User.blueprint do
  tmp = Faker::Lorem.characters(5)
  name { Faker::Lorem.word }
  password { tmp }
  password_confirmation { tmp }
  email {Faker::Internet.email }
  roles { ["traveler"] }
end
