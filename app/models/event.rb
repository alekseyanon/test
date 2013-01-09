class Event < ActiveRecord::Base
  include IceCube
  include PgSearch
  attr_accessible :body, :title, :duration, :start_date, :repeat_rule, :landmark_id, :image, :geom

  serialize                   :schedule, Hash
  mount_uploader              :image,    ImageUploader
  set_rgeo_factory_for_column :geom,     Geo::factory

  belongs_to :user
  belongs_to :landmark
  has_many   :event_occurrences

  validates :title, :start_date, :geom, presence: true
  validates_associated :user, :landmark

  after_create :event_after_create

  pg_search_scope :text_search,
                  against: {title: 'A', body: 'B'}                  

  scope :within_radius, ->(geom, r) do
    where "ST_DWithin(geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end

  def self.search(query)
    return all unless query && !query.empty?
    if query.is_a? String
      text = query
    else
      # Удаление пустых ключей.. ээ.. а разве blank? не тоже самое делает?
      query = query.delete_if { |k, v| v.nil? || (v.is_a?(String) && v.empty?) }
      text  = query[:text]
      geom  = query[:geom] || ((y = query[:x]) && (x = query[:y]) && Geo::factory.point(x.to_f, y.to_f)) #TODO mind x y
      r     = query[:r] || 0
      date  = query[:date]
    end
    chain = self
    if date
      chain = chain.joins('JOIN event_occurrences ON event_occurrences.event_id = events.id')
      chain = chain.where date
    end    
    chain = chain.text_search(text) if text
    chain = chain.within_radius(geom, r) if geom
    chain.limit 20
  end

  def event_after_create
    if self.repeat_rule.blank?
      self.create_occurrence self.start_date
    else
      self.create_schedule self.start_date, self.repeat_rule
      self.create_occurrences
    end
  end

  def create_schedule start_date, repeat_rule
    schedule = Schedule.new start_date
    rule = case repeat_rule
    when 'daily'
      Rule.daily
    when 'weekly'
      Rule.weekly
    when 'monthly'
      Rule.monthly
    when 'yearly'
      Rule.yearly
    when 'half-year'
      Rule.monthly(6)
    else
      raise "Unknown repeat rule: #{repeat_rule}"
    end
    schedule.add_recurrence_rule rule
    self.schedule=schedule
    schedule
  end

  def schedule=(schedule)
    write_attribute(:schedule, schedule.to_hash)
  end

  def schedule
    Schedule.from_hash(read_attribute(:schedule))
  end

  def create_occurrences
    self.schedule.first(10).each do |datetime|
      create_occurrence datetime
    end
  end

  def create_occurrence start_date
    self.event_occurrences.create! start: start_date
  end

end
