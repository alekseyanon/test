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

  version :chronicalthumb do
    resize_to_fill(130, 90)
  end

  version :showthumb do
    resize_to_fill(724, 485)
  end
  
  version :objmainthumb do
    resize_to_fill(504, 337)
  end
  
  version :objsecthumb do
    resize_to_fill(237, 137)
  end

  version :eventmainthumb do
    resize_to_fill(223, 334)
  end
  
  version :eventsecthumb do
    resize_to_fill(109, 75)
  end

end
