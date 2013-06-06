
class Routes 
  include Rails.application.routes.url_helpers
end

Routes.default_url_options[:host] = "localhost:3000"
r = Routes.new


def create_comment commentator, commentable, parent = nil
  commentator.comments.create! commentable: commentable, body: Faker::Lorem.word, parent: parent
end

def commentators
  User.last(5)
end

def each_commentator
  commentators.each {|c| yield c }
end

def generate_children comment
  depth = Random.rand(0..2)
  depth.times do
    Random.rand(1..3).times do |r|
      random_commentator = commentators.select{ |c| c.id != comment.user.id }.sample
      create_comment random_commentator, comment.commentable, comment
      comment.save!
      puts "Commentator: #{random_commentator.id}, Comment: #{comment.children.last.id}, Parent comment: #{comment.id}"
    end
    comment = Comment.find(comment.children.sample)
  end
end

namespace :fake do
  desc 'Generates fake comments for GeoObject and User'
  task comments: [:users, :reviews] do

    puts '-------------------------------------------------------------------------'
    puts '-------------------------- CREATING COMMENTS ----------------------------'
    puts '-------------------------------------------------------------------------'
    each_commentator do |commentator|
      [Review.last(5), User.last(5)].each do |commentable_list|
        commentable_list.each do |commentable|
          c    = create_comment commentator, commentable
          link = commentable.is_a?(User) ? r.profile_url(commentable.profile) : r.geo_object_url(commentable)
          puts ">>> Building comments for #{commentable.class} #{link} <<<"
          generate_children c
        end
      end
    end
  end
end
