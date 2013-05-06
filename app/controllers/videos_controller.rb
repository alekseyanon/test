class VideosController < InheritedResources::Base
  before_filter :find_parent_model
  before_filter :load_youtube #TODO remove hack, consider moving to initializers
  def load_youtube
    Video
    YouTube
  end
  def index
    @videos = @parent.you_tubes
  end

  def show
    @video = Video.find(params[:id])
  end

  def new
    @video = @parent.you_tubes.new
  end

  def create
    @video_link = VideoLink.find_or_create_by_content current_user, @parent, params[:you_tube][:url]
    @video = @video_link.try(:video)
    if @video
      redirect_to polymorphic_url([@parent, Video])
    else
      respond_with do |format|
        format.html { render action: :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end
end
