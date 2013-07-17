class Api::ImagesController < ApplicationController
  before_filter :find_parent_model

  def show
    @image = Image.find params[:id]
    imgs = @image.imageable.images
    @image_total = imgs.count
    @image_number = imgs.index(@image) + 1
  end
end
