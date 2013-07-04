class SearchQuery < ActiveRecord::Base
  
  belongs_to :user

  validates :str, presence: true, uniqueness: true

  def self.add str, user = nil
    sq = self.find_or_initialize_by_str str.mb_chars.downcase.to_s
    sq.user = user
    sq.save
    sq.increment! :counter
  end

  def self.popular_for str
    str = str.mb_chars.downcase.to_s
    self.where("str LIKE '%#{str}%'").order('counter DESC').limit(10).pluck :str
  end

  def self.history_for_user user, limit = 3
    where(user_id: user.id).order('updated_at DESC').limit(limit).pluck(:str) if user
  end

end
