class ImagesController < InheritedResources::Base
  before_filter :find_parent_model
  def index
    @images = @parent.images
  end

  def show
    @image = Image.find params[:id]
    @image_total = @image.imageable.images.count
    @image_number = @image_total - @image.imageable.images.where('id < ?', @image.id).count
    @comment_roots  = @image.comments.roots.order 'created_at asc'
		respond_to do |format|
			format.html
			format.js
		end
  end

  def new
    @image = @parent.images.new
  end

  def create
    @image = @parent.images.build params[:image]
    @image.user = current_user
    if @image.save
      respond_to do |format|
        format.html { redirect_to polymorphic_url([@parent]) }
        format.json { render json: [@image.to_jq_upload].to_json }
      end
    else
      respond_with do |format|
        format.html { render action: :new }
        format.json { render json: {errors: @image.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end
end
