class Agu < ActiveRecord::Base
	# Административно георафическая единица (юнит)
  include PgSearch
  include Searchable
  attr_accessible :geom, :place, :title
  validates :title, :geom, presence: true
  pg_search_scope :text_search, against: {title: 'A'}

  def agcs
  	Agc.where('? = ANY(agcs.agus)', id)
  end

end
