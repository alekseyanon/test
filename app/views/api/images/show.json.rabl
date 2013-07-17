extends 'api/shared/rating'
extends 'api/shared/complaints'
extends 'api/shared/date'
extends 'api/shared/comments'
extends 'api/shared/user'

object @image
attributes :id, :created_at

node(:title) {|img| img.imageable.title}
node(:src) {|img| img.image_url}
node(:image_total) {@image_total}
node(:image_number) {@image_number}

