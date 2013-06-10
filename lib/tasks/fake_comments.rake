def create_comment commentator, commentable, parent = nil
  body = Faker::Lorem.sentences(Random.rand(1..7)).join
  commentator.comments.create! commentable: commentable, body: body, parent: parent
end

def commentators
  User.last(5)
end

def generate_children comment
  depth = Random.rand(0..1)
  depth.times do
    Random.rand(1..3).times do
      random_commentator = commentators.select{ |c| c.id != comment.user.id }.sample
      create_comment random_commentator, comment.commentable, comment
      puts "Commentator: #{random_commentator.id}, Comment: #{comment.children.last.id}, Parent comment: #{comment.id}"
    end
    comment = Comment.find(comment.children.sample)
  end
end

namespace :fake do
  desc 'Generates fake comments for GeoObject and User'
  task comments: [:users, :reviews] do
    load_routes
    puts '-------------------------------------------------------------------------'
    puts '-------------------------- CREATING COMMENTS ----------------------------'
    puts '-------------------------------------------------------------------------'
    commentators.each do |commentator|
      [Image.last(5), Review.last(5)].each do |commentable_list|
        commentable_list.each do |commentable|
          comment = create_comment(commentator, commentable)
          link    = if commentable.is_a? Image
                      geo_object_image_url(commentable.imageable, commentable)
                    else
                      review_url(commentable)
                    end
          puts ">>> Building comments for #{commentable.class} [#{link}] on behalf of User [#{commentator.email}]<<<"
          generate_children comment
        end
      end
    end
  end
end
