module UserFeatures
  module Ratings

    RATINGS = { commentator:  1.08,
                photographer: 1.20,
                expert:       1.30,
                discoverer:   1.40,
                blogger:      1.42 }.freeze

    RATINGS_TABLE = { comments:     :commentator,
                      images:       :photographer,
                      reviews:      :expert,
                      runtips:      :expert,
                      geo_objects:  :discoverer
                      #posts:       :blogger
                    }

    def rating
      RATINGS.map { |rating, rate| self[rating] }.sum
    end

    def update_rating(voteable, delta)
      unless voteable.is_a? Symbol
        voteable = voteable.class.table_name.to_sym
      end
      model = RATINGS_TABLE[voteable]
      k = RATINGS[model]
      if model
        self[model] += delta*k
        self.save!
      end
    end

    def update_rating_all
      time = self.rating_updated_at
      RATINGS_TABLE.each do |model, rating|
        delta = if model == :geo_objects
                  self.send(model).created_after(time).count
                else
                  recommenders(model, time)
                end
        self[rating] += delta * RATINGS[rating]
      end
      self.rating_updated_at = Time.now
      self.save!
    end

    def clear_rating_all
      RATINGS.each_key { |rating| self[rating] = 0.0 }
      self.rating_updated_at = nil
      self.save!
    end

    def rebuild_rating_all
      clear_rating_all
      update_rating_all
    end

    def recommenders(voteable, time = nil)
      # можно заменить plusminus_tally на tally, если не планируются дизлайки
      result = self.send(voteable).plusminus_tally
      result = result.where('votes.created_at > ?', time) if time
      result.map { |x| x.plusminus_tally.to_i }.sum
    end

    def recommenders_last_sign_in(voteable)
      recommenders voteable, self.last_sign_in_at
    end

    def recommenders_last_hour(voteable)
      recommenders voteable, 1.hour.ago
    end

    def get_vote voteable, tag = nil
      args = {voteable_id: voteable.id, voteable_type: voteable.class}
      args.merge!(voteable_tag: tag) if tag
      v = self.votes.where(args).first
      v.nil? ? 0 : (v.vote ? 1 : -1)
    end

  end
end
