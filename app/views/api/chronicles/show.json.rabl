collection @objects
attributes :id, :title, :created_at

node(:url) {|obj| geo_object_path(obj)}
node(:date) {|obj| obj.created_at.strftime('%d %b %y')}
node(:agc_titles) {|obj| obj.agc.try(:titles) || ''}

child :user do
  code(:username) { |m| m.profile.try(:name) || m.try(:email) || "Пользователь #{u.id}"}
  ### TODO: shared/user in klamath repo
  code(:userlink) { |m| profile_path(m.profile) }
end

node(:image) {|obj| obj.images.first.try(:image_url) || '' }
