class Comment < ActiveRecord::Base
  has_ancestry
  attr_accessible :body
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  acts_as_voteable

  # TODO disable for migration on Ancestry
  # after_create :send_notifications

  validates :body, :user, :commentable, presence: true
  validates_associated :user, :commentable

  def send_notifications
    if self.level == 0 and self.user.id != self.commentable.user.id and self.commentable.user.profile.settings['record_comment_mailer']
      Notifier.send_new_comment_on_review_notification(self.commentable).deliver
    end
  end

end
