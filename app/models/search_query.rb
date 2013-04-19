class SearchQuery < ActiveRecord::Base

  validates :str, presence: true, uniqueness: true

  def self.add str
    sq = self.find_or_create_by_str str.mb_chars.downcase.to_s
    sq.increment! :counter
  end

  def self.popular_for str
    str = str.mb_chars.downcase.to_s
    self.where("str LIKE '%#{str}%'").order('counter DESC').limit(10).pluck :str
  end

end
