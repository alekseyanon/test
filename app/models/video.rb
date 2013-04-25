class Video < ActiveRecord::Base
  URL_REGEX = /(?:https?:\/\/)?(?:www.)?(?<type>youtube|vimeo)\.com\/(?:watch\?v=)?(?<id>\w{11}|\d{8})(?:(&|#).*)?/
  VIDEO_TYPES = {'youtube' => YouTube, 'vimeo' => Vimeo}
  self.primary_key = :vid


  attr_accessible :movie_stars, :movie_star_id, :movie_star_type, :type, :url, :users, :vid
  attr_accessor :url

  has_many :video_links, foreign_key: :video_id, primary_key: :vid
  has_many :users, through: :video_links
  has_many :movie_stars, through: :video_links,  source: :movie_star, source_type: 'LandmarkDescription'

  def self.find_or_create_by_url(url)
    type, id = type_and_id_from_url url
    Video.find_or_create_by_type_and_vid(type.name, id).becomes type if type && id
  end

  protected
  def self.type_and_id_from_url(url)
    md = URL_REGEX.match url
    md && [VIDEO_TYPES[md[:type]], md[:id]]
  end
end
