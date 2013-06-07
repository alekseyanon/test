collection @objects
attributes :id, :title, :agc_id

node(:url) {|obj| geo_object_path(obj)}
node(:date) {|obj| Russian::strftime(obj.created_at, '%A, %e %B %Yг.') }
node(:agc_titles) {|obj| obj.agc.try(:titles) || ''}

child :user do
  code(:username) { |m| m.profile.try(:name) || m.try(:email) || "Пользователь #{u.id}"}
  code(:link_to_profile) { |m| profile_path(m.profile) }
end

node(:image) {|obj| (imgs = obj.images).blank? ? '/assets/tmp/130x90.gif' : imgs.first.image_url(:chronicalthumb) }
