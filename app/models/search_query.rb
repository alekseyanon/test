class SearchQuery < ActiveRecord::Base

  validates :str, presence: true, uniqueness: true

  def self.add str
    #REVIEW transaction is not necessary here?
    sq = self.find_or_create_by_str str.mb_chars.downcase.to_s
    sq.update_column :counter, sq.counter+1
  end

  def self.popular_for str
    str = str.mb_chars.downcase.to_s
    self.where("str LIKE '%#{str}%'").order('counter DESC').limit(10).map {|sq| sq.str }
  end

end
