class Event < ActiveRecord::Base
  # = События
  #
  # События могут быть повторяющимися и не пе повторяющимися, все возможные варинаты перечислены
  # в <tt>Event::REPEAT_RULES</tt>.
  #
  # == JS API
  #
  # GET /api/events/week позволяет получить все события от date до date+7.days
  # Параметры:
  # date - ISO 8601 date format - обязательный
  #
  # GET /api/events/tags возвращает все возможные теги событий.
  #
  # GET /api/events/search посзволяет искать события по следующим параметрам:
  # Параметры:
  # text - строка для полнотекстового поиска
  # from, to - границы периода времени, внутри которого искать
  # place_id - место для поска @TODO
  # tag_id - только события с определенным тегом @TODO
  # sort_by - задает сортировку и может принимать значения: 'date' или 'rate' @TODO
  # page - номаер страницы результатов поиска @TODO
  # Если не передать параметров - вернуться события на сегодня
  #
  # Чтобы посмотреть формат JSON ответа можно обратиться к соответсвующим спекам:
  # rspec -fd spec/controllers/api/events_controller_spec.rb

  include PgSearch
  include Searchable
  require 'digest/sha2'

  REPEAT_RULES = [:no_repeat, :weekly, :monthly, :monthly_weekly,
                  :quarterly, :halfyear, :yearly,
                  :two_years, :three_years, :four_years]

  FEEDBACK_DURATION = { no_repeat: 3.days,
                        weekly: 3.days,
                        monthly: 7.days,
                        monthly_weekly: 7.days}

  FEEDBACK_DURATION.default 30.days

  attr_accessible :body, :title, :start_date, :end_date,
                  :repeat_rule, :geom,
                  :images_attributes, :event_tags, :tag_list

  before_create :generate_key, :calc_archive_date

  # TODO delete EO table
  # TODO написать таску для прогона событий по состояниям
  # TODO написать генерацию fake событий для удобства тестирования

  set_rgeo_factory_for_column :geom, Geo::factory

  belongs_to :user
  has_many   :event_taggings
  has_many   :event_tags, through: :event_taggings
  has_many   :images,   as: :imageable

  accepts_nested_attributes_for :images

  validates :title, :start_date, :end_date, :geom, :repeat_rule, presence: true
  validate  :validate_tags
  validate  :validate_duration
  validate  :validate_repeat_rule
  validates_associated :user

  def validate_tags
    errors.add(:event_tags, "need at least 1 tag") if event_tags.length < 1
  end

  def validate_duration
    if weekly? && duration > 4
      errors.add(:event_end_date, 'duration must be less then 4 days')
    elsif duration > 20
      errors.add(:event_end_date, 'duration must be less then 20 days')
    elsif duration < 1
      errors.add(:event_end_date, 'duration must be more then 1 day')
    end
  end

  def validate_repeat_rule
    errors.add(:event_repeat_rule, 'unknown repeat rule') if not REPEAT_RULES.include?(repeat_rule)
  end

  scope :newest, order('created_at DESC')
  scope :line, ->(key) { where key: key}

  pg_search_scope :text_search,
                  against: {title: 'A', body: 'B'}

  scope :within_radius, ->(geom, r) do
    where "ST_DWithin(geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end

  scope :within_date_range, ->(from, to) do
    where 'start_date >= ? AND start_date <= ?', from, to
  end

  scope :for_7_days_from, -> interval_start do
    where 'start_date >= ? AND start_date <= ?', interval_start, interval_start + 7.days
  end


  state_machine initial: :new do

    after_transition on: :archive, do: :create_next_event

    event :start do
      transition from: :new, to: :started
    end

    event :stop do
      transition from: :started, to: :ended
    end

    event :archive do
      transition from: :ended, to: :archived
    end

    event :cancel do
      transition to: :canceled
    end

    # TODO Конец всему/Горшочек не вари

  end

  def create_next_event
    if multiple?
      next_event = self.dup
      next_event.start_date = start_date + repeat_period
      next_event.end_date = end_date + repeat_period
      next_event.tag_list = tag_list
      next_event.state = 'new'
      next_event.save
    end
  end

  # Returns duration in days as float
  def duration
    # TODO REVIEW to_f
    (end_date - start_date).to_f / 1.day
  end

  # Add mehods weekly?, monthly?, etc. to instance
  REPEAT_RULES.each do |rr|
    define_method(rr.to_s+'?') { repeat_rule == rr }
  end

  # Always symbolize repeat_rule
  def repeat_rule
    super.try :to_sym
  end

  def repeat_rule=(value)
    super(value.to_sym)
    repeat_rule
  end

  def multiple?
    repeat_rule != :no_repeat
  end

  def update_state!
    if date_for_next_state && date_for_next_state < Time.now
      process_to_next_state
    elsif date_for_next_state.nil?
      raise 'No next state'
    else
      raise 'Too early for next state'
    end
  end

  def date_for_next_state
    return nil if archived? or canceled?
    return start_date if new?
    return end_date if started?
    return archive_date if ended?
  end

  def tag_list
    event_tags.map(&:title).join(", ")
  end

  def tag_list=(names)
    self.event_tags = names.split(",").map do |n|
      EventTag.where(title: n.strip).first_or_create!
    end
  end

  def repeat_period
    0 if not multiple?
    @repeat_period ||= if weekly?; 1.weeks
    elsif monthly?; 1.months
    elsif quarterly?; 3.months
    elsif halfyear?; 6.months
    elsif yearly?; 1.years
    elsif two_years?; 2.years
    elsif three_years?; 3.years
    elsif four_years?; 4.years
    end
  end

  private

    def calc_archive_date
      self.archive_date = end_date + FEEDBACK_DURATION[repeat_rule]
    end

    def generate_key
      # TODO гарантировать уникальность между линиями событий
      self.key = Digest::SHA2.hexdigest title+start_date.to_s if key.blank? and multiple?
    end

    def process_to_next_state
      if new?
        start
      elsif started?
        stop
      elsif ended?
        archive
      end
    end

end
