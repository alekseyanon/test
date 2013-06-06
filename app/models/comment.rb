class Comment < ActiveRecord::Base
  has_ancestry cache_depth: true
  attr_accessible :body, :commentable, :parent
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  has_many :complaints, as: :complaintable
  acts_as_voteable

  # TODO disable for migration on Ancestry
  # after_create :send_notifications

  validates :body, :user, :commentable, presence: true
  validates_associated :user, :commentable
  validates_numericality_of depth_cache_column, greater_than_or_equal_to: 0, less_than_or_equal_to: 2

  def send_notifications
    if self.level == 0 and self.user.id != self.commentable.user.id and self.commentable.user.profile.settings['record_comment_mailer']
      Notifier.send_new_comment_on_review_notification(self.commentable).deliver
    end
  end

end
