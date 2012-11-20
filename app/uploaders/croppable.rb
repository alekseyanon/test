module Croppable
  extend ActiveSupport::Concern

  included do
    model_delegate_attribute :x
    model_delegate_attribute :y
    model_delegate_attribute :w
    model_delegate_attribute :h
  end

  def crop_args
    [].tap do |args|
      %w(x y w h).each do |accessor|
        args << send(accessor).to_i
      end
    end
  end

  def crop_to(width, height, default)
    if ((crop_args[0] == crop_args[2]) || (crop_args[1] == crop_args[3]))
      instance_exec(&default)
    else
      args = crop_args + [width, height]
      crop_and_resize(*args)
    end
  end

  def crop_and_resize(x, y, width, height, new_width, new_height)
    manipulate! do |img|
      cropped_img = img.crop(x, y, width, height)
      new_img = cropped_img.resize_to_fill(new_width, new_height)
      destroy_image(cropped_img)
      destroy_image(img)
      new_img
    end
  end

  def resize_to_fill_and_save(new_width, new_height)
    manipulate! do |img|
      width, height = img.columns, img.rows
      new_img = img.resize_to_fill(new_width, new_height)
      destroy_image(img)

      w_ratio = width.to_f / new_width.to_f
      h_ratio = height.to_f / new_height.to_f

      ratio = [w_ratio, h_ratio].min

      self.w = ratio * new_width
      self.h = ratio * new_height
      self.x = (width - self.w) / 2
      self.y = (height - self.h) / 2

      new_img
    end
  end
end
