# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
     %w(jpg jpeg gif png)
  end

  version :thumb do
    resize_to_fill(100, 100)
  end
	
	version :indexthumb do
    resize_to_fill(139, 97)
  end

end
