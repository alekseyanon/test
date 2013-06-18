object false

node(:go_offset) do
  @go_offset.to_s
end

node(:event_offset) do
  @event_offset.to_s
end

child @objects => :items do
  attributes :id, :title, :agc_id

  node(:type) {|obj| obj.class.to_s.underscore}
  node(:url) {|obj| url_for(obj)}
  node(:date) {|obj| Russian::strftime(obj.created_at, '%A, %e %B %Yг.') }
  node(:agc_titles) {|obj| obj.agc.try(:titles) || ''}

  child :user do
    code(:username) { |m| m.try(:name) || m.try(:email) || "Пользователь #{u.id}"}
    code(:link_to_profile) { |m| profile_path(m.profile) || '' }
  end
  # TODO: move stub for the pictures
  node(:image) {|obj| (imgs = obj.images).blank? ? '/assets/tmp/130x90.gif' : imgs.first.image_url(:chronicalthumb) }
end
