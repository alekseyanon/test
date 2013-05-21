class Image < ActiveRecord::Base
  attr_accessible :image, :remote_image_url
  mount_uploader  :image, ImageUploader
  belongs_to      :imageable, polymorphic: true
  belongs_to      :user

  has_many        :comments,    as: :commentable
  has_many        :complaints,  as: :complaintable
  belongs_to      :imageable, polymorphic: true
  acts_as_voteable

  validates :image, :user, :imageable, presence: true
  def to_jq_upload
    {
      "name" => read_attribute(:image),
      "size" => image.size,
      "url" => image.url,
      "thumbnail_url" => image.thumb.url,
      "delete_url" => id,
      "picture_id" => id,
      "delete_type" => "DELETE"
    }
  end
end
