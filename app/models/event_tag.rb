class EventTag < ActiveRecord::Base
  attr_accessible :title
  has_many :events, through: :event_taggings

  validates :title, presence: true
  validates :title, uniqueness: true

  scope :system, where(system: true)
  scope :user, where(system: false)

  def as_json options = {}
    super only: [:id, :title, :system]
  end

end
