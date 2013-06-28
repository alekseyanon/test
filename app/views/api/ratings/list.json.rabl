collection @users
attributes :id, :expert, :discoverer, :photographer, :blogger, :commentator
node(:total_rating) {|user| user.expert + user.discoverer + user.photographer + user.blogger + user.commentator}
node(:username) {|user| user.name}
node(:avatar) {|user| user.avatar_url(:image_author_thumb)}
