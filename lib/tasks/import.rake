#encoding: utf-8

namespace :import do

  task file: :environment do

    file_for_import = ARGV.last
    extension = File.extname(file_for_import)

    case extension
    when '.yml'
      objects = YAML.load_file(file_for_import)
    when '.json'
      objects = JSON.parse File.read(file_for_import), symbolize_names: true
    else
      raise "Need json or yaml file to process"
    end

    create_objects objects

  end

  task db: :environment do
    conn = PG.connect( dbname: 'datamining' )
    result = conn.exec('select * from landmarks where lonlat is not null AND categories is not null limit 10')
    objects = []
    test = []
    result.each do |r|
      # next if r['name'].blank? or r['lonlat'].blank? or r['categories'].blank?
      # test << r
      lon, lat = r["lonlat"].gsub(/[{}]/, '').split ','
      categories = r['categories'].gsub(/[{}]/, '').split ','
      phones = r['phones'] ? r['phones'].gsub(/[{}]/, '').split(',') : []
      sites = r['sites'] ? r['sites'].gsub(/[{}]/, '').split(',') : []
      emails = r['emails'] ? r['emails'].gsub(/[{}]/, '').split(',') : []

      objects << {
        title: (r['name'] || 'NoName'),
        lon: lon,
        lat: lat,
        categories: categories,
        address: r['address'],
        phones: phones,
        sites: sites,
        emails: emails
      }
    end
    binding.pry
  end

end

def create_objects objects

  load "#{Rails.root}/spec/support/blueprints.rb"
  user = User.make!
  next_id = Osm::Node.order("id DESC").pluck(:id).first || 0

  objects.each do |obj|
    next_id += 1
    # TODO много категорий
    category = Category.find_by_name_ru obj[:categories].first
    if category.nil?
      puts "No category #{obj[:categories].first}"
      next
    end
    node = Osm::Node.make! geom: "POINT(#{obj[:lon]} #{obj[:lat]})", id: next_id
    landmark = Landmark.make! osm: node
    ld = LandmarkDescription.make! describable: landmark,
      title: obj[:title],
      body: obj[:address],
      user: user,
      tag_list: category.name
  end

end
