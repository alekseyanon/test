collection @objects
attributes :id, :title, :created_at

node(:agc_titles) {|obj| obj.agc.try(:titles) || ''}

child :user do
  code(:username) { |m| m.profile.try(:name) || m.try(:email) || "Пользователь #{u.id}"}
end

node(:image) {|obj| obj.images.first.try(:image_url) || '' }
