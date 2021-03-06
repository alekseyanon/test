class VideoLink < ActiveRecord::Base
  attr_accessible :user, :movie_star, :video, :video_type
  belongs_to :user
  belongs_to :video, foreign_key: :video_id, primary_key: :vid, polymorphic: true
  belongs_to :movie_star, polymorphic: true

  def self.find_or_create_by_content(user, movie_star, url)
    video = Video.find_or_create_by_url url
    if video
      existing_link = VideoLink.find_by_user_id_and_movie_star_id_and_movie_star_type_and_video_id(
          user.id,
          movie_star.id,
          movie_star.class,
          video.vid)
      existing_link || VideoLink.create(user: user, movie_star: movie_star, video: video, video_type: video.type)
    end
  end
end
