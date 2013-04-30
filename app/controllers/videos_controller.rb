class VideosController < InheritedResources::Base
  before_filter :find_video_star_model
  before_filter :load_youtube #TODO remove hack, consider moving to initializers
  def load_youtube
    Video
    YouTube
  end
  def index
    @videos = @video_star.you_tubes
  end

  def show
    @video = Video.find(params[:id])
  end

  def new
    @video = @video_star.you_tubes.new
  end

  def create
    @video_link = VideoLink.find_or_create_by_content current_user, @video_star, params[:you_tube][:url]
    @video = @video_link.video
    if @video
      redirect_to polymorphic_url([@video_star, Video])
    else
      respond_with do |format|
        format.html { render action: :new }
        format.json { render json: @video_star.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_video_star_model
    [[:event_id, Event],
     [:geo_object_id, GeoObject]].each do |(key, video_star_class)|
      return @video_star = video_star_class.find(params[key]) if params.has_key? key
    end
  end
end
