def vote_for_geo_object obj, user, decision
  if obj.leaf_categories.present?
    obj.leaf_categories.each {|tag| user.send decision, obj, tag }
    rating = ld.plusminus.to_f / ld.leaf_categories.count.to_f
  else
    user.send decision, obj
    rating = obj.plusminus.to_f
  end
  obj.update_attributes rating: rating
end

namespace :fake do
  paths = {}
  paths[:geo_objects]    = ->(obj)     { geo_object_path(obj)  }
  paths[:comments]       = ->(comment) { review_path(comment.commentable) }
  paths[:reviews]        = ->(review)  { review_path(review)   }
  paths[:runtips]        = ->(runtip)  { geo_object_path(runtip.geo_object)   }

  desc 'Generate simple votes for geo_object, comments, runtips, reviews'
  task rating: [:comments, :reviews, :runtips, :users] do
    load_routes
    votables = [GeoObject, Comment, Review, Runtip]
    users    = User.last(5)
    votables.each do |votable_class|
      votable_class.last(5).each do |obj|
        users.sample(rand(1..5)).each do |u|
          decision = [:vote_exclusively_for, :vote_exclusively_against].sample 
          path_key = obj.class.to_s.tableize.to_sym
          if votable_class == GeoObject
            vote_for_geo_object(obj, u, decision) 
          else
            u.send decision, obj
          end
          puts "User #{u.email} #{decision} #{votable_class} #{paths[path_key].call(obj)}"
        end
      end
    end
  end
end
