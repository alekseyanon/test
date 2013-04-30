class ImagesController < InheritedResources::Base
  def index
    @geo_object = GeoObject.find(params[:geo_object_id])
    @images = @geo_object.images
  end

  def new
    @geo_object = GeoObject.find(params[:geo_object_id])
    @image = @geo_object.images.new
  end

  def create
    @geo_object = GeoObject.find(params[:geo_object_id])
    @image = @geo_object.images.build params[:image]
    ### TODO: temporary comment(for Dima)
    #@image.user = current_user
    if @image.save
      redirect_to geo_object_image_path(@geo_object, @image)
    else
      respond_with do |format|
        format.html { render action: :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end
end
