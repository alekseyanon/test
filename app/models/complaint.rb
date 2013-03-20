class Complaint < ActiveRecord::Base
  belongs_to :user
  belongs_to :complaintable, polymorphic: true
  attr_accessible :content
  validates :content, :user, :complaintable, presence: true
end
