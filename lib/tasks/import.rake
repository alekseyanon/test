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

    create_mapping_objects objects

  end

  task db: :environment do
    conn = PG.connect( dbname: 'datamining' )
    result = conn.exec('select * from landmarks where lonlat is not null AND categories is not null')
    objects = []
    test = []
    result.each do |r|
      # next if r['name'].blank? or r['lonlat'].blank? or r['categories'].blank?
      # test << r
      lon, lat = r["lonlat"].gsub(/[{}]/, '').split ','
      categories = r['categories'].gsub(/[{}"]/, '').split ','
      phones = r['phones'] ? r['phones'].gsub(/[{}]/, '').split(',') : []
      sites = r['sites'] ? r['sites'].gsub(/[{}]/, '').split(',') : []
      emails = r['emails'] ? r['emails'].gsub(/[{}]/, '').split(',') : []

      objects << {
        title: (r['name'].blank? ? 'NoName' : r['name']),
        lon: lon,
        lat: lat,
        categories: categories,
        address: r['address'],
        phones: phones,
        sites: sites,
        emails: emails
      }
    end
    create_mapping_objects objects
  end

end

def create_mapping_objects objects

  load "#{Rails.root}/spec/support/blueprints.rb"
  user = User.make!

  objects.each do |obj|
    categories = categories_process obj[:categories]
    next if categories.blank?
    next if obj[:address].blank?
    geo_object = GeoObject.make! geom: "POINT(#{obj[:lon]} #{obj[:lat]})",
      title: obj[:title],
      body: obj[:address],
      user: user,
      tag_list: categories
    puts "Created #{geo_object.title}"
  end

end

def categories_process categories
  cats_out = []
  categories.each do |cat|
    c = Category.find_by_name_ru cat
    if c.nil?
      puts "No category found #{cat}"
      next
    end
    cats_out << c.name
  end
  cats_out.join ', '
end
