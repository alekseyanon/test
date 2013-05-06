class ImagesController < InheritedResources::Base
  before_filter :find_parent_model
  def index
    @images = @parent.images
  end

  def new
    @image = @parent.images.new
  end

  def create
    @image = @parent.images.build params[:image]
    @image.user = current_user
    if @image.save
      redirect_to polymorphic_url([@parent, @image])
    else
      respond_with do |format|
        format.html { render action: :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_imageable_model
    [[:event_id, Event],
     [:geo_object_id, GeoObject]].each do |(key, imageable_class)|
      return @parent = imageable_class.find(params[key]) if params.has_key? key
    end
  end
end
