namespace :fake do
  desc 'Generates fake agus to make location determining on map work'
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
