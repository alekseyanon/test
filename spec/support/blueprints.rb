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

Category.blueprint do
  name { Faker::Lorem.word }
  name_ru { Faker::Lorem.word }
  description { Faker::Lorem.sentence 2 }
end

GeoObject.blueprint do
  user { User.make! }
  title { Faker::Lorem.sentence }
  body { Faker::Lorem.sentences 10 }
  published { [true, false].sample }
  published_at { Time.now }
  geom { Geo::factory.point(29.9918672, 60.0052767) }
end

User.blueprint do
  pwd = Faker::Lorem.characters(9)
  password { pwd }
  password_confirmation { pwd }
  email { "test#{sn}" + Faker::Internet.email }
  #roles { ["traveler"] }
  profile { Profile.make! }
end

Event.blueprint do
  title { Faker::Lorem.sentence }
  body { Faker::Lorem.sentences 10 }
  start_date { Time.now }
  end_date { object.start_date + 2.days }
  repeat_rule { :single }
  geom { Geo::factory.point(10, 10) }
  tag_list { 'aaa, bbb, ccc' }
  user { User.make! }
end

Review.blueprint do
  title { Faker::Lorem.sentence }
  body { Faker::Lorem.sentences 10 }
  user { User.make! }
  reviewable { GeoObject.make! }
end

Image.blueprint do
  image { File.open("#{Rails.root}/spec/fixtures/images/fishing/toon376.gif") }
  imageable { GeoObject.make! }
end

Comment.blueprint do
  body { Faker::Lorem.sentences 3 }
  user { User.make! }
  commentable { Review.make! }
end

Profile.blueprint do
  name { Faker::Lorem.word }
end

Complaint.blueprint do
  content { Faker::Lorem.sentences 3 }
  user { User.make! }
  complaintable { Review.make! }
end

EventTag.blueprint do
  title { Faker::Lorem.word }
end

Agc.blueprint do
  agus { [1, 2, 3] }
end

Authentication.blueprint do
  uid {Time.now.to_i}
  provider {'facebook'}
  user {User.make!}
end

Video.blueprint do
  ids = %w(n0SVG6SgirE 3eRxPDLYM9Q TRbLicNOvzY BHjg6cTxmrQ)
  vid { (ids - Video.pluck(:vid)).sample }
end

Agu.blueprint do
  title { Faker::Lorem.sentence }
  geom { 'POLYGON((0 0, 1 0, 0 1, 0 0))' }
end
