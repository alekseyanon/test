class Vote < ActiveRecord::Base

  scope :for_voter, ->(id, type) { where ["voter_id = ? AND voter_type = ?", id, type] }
  scope :for_voteable, ->(id, type) { where ['voteable_id IN (?) AND voteable_type = ?', id, type] }
  scope :from_time, ->(time) { where ["created_at > ?", (time || Time.now - 1.hour)] }
  scope :descending, order("created_at DESC")

  belongs_to :voteable, polymorphic: true
  belongs_to :voter, polymorphic: true

  attr_accessible :vote, :voter, :voteable, :voteable_tag


  # Comment out the line below to allow multiple votes per user.
  validates_uniqueness_of :voteable_id, scope: [:voteable_type, :voter_type, :voter_id, :voteable_tag]

end
