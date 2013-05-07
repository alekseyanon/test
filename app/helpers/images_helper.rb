module ImagesHelper

  def prev_image image
		image.imageable.images.where('id > ?', image.id).order('id').limit(1).first
  end

  def next_image image
		image.imageable.images.where('id < ?', image.id).order('id desc').limit(1).first
  end

  def last_image image
		image.imageable.images.order('id').limit(1).first
  end

  def first_image image
		image.imageable.images.order('id desc').limit(1).first
  end

end
