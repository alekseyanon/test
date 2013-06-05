
# TODO: Manually set User to comment

def create_comment commentator, commentable, parent = nil
  commentator.comments.create! commentable: commentable, body: Faker::Lorem.word, parent: parent
  commentator.comments.last
end

def commentators
  User.first(5)
end

def each_commentator
  commentators.each {|c| yield c }
end

def generate_children comment
  depth = Random.rand(1..3)
  depth.times do
    Random.rand(1..3).times do |r|
      random_commentator = commentators.find{ |c| c.id != comment.user.id }
      create_comment random_commentator, comment.commentable, comment
      comment.save!
      puts "Commentator: #{random_commentator.id}, Comment: #{comment.children.last.id}, Parent comment: #{comment.id}"
    end
    comment = Comment.find(comment.children.sample)
  end
end

namespace :fake do
  desc 'Generates fake comments for GeoObject and User'
  task comments: :environment do
    load "#{Rails.root}/spec/support/blueprints.rb"

    each_commentator do |commentator|

      [Review, User].each do |commentable_class|
        2.times do
          commentable = commentable_class.make!
          4.times do
            c = create_comment commentator, commentable
            puts "-------------------------------------------------------"
            puts "Building comments for #{commentable_class} #{commentable.id}"
            puts "-------------------------------------------------------"
            generate_children c
          end
        end
      end

    end

  end
end
