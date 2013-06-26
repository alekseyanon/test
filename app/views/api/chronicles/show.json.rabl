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
  node(:tags) {|obj| obj.tags_titles if obj.is_a? Event}
  node(:url) {|obj| url_for(obj)}
  node(:creation_date) {|obj| Russian::strftime(obj.created_at, '%A, %e %B %Yг.') }
  node(:start_end_dates) { |obj| obj.event_dates if obj.is_a? Event}
  node(:state) { |obj| obj.state if obj.is_a? Event}
  node(:agc_titles) {|obj| obj.agc.try(:titles) || ''}

  child :user do
    code(:username) { |m| m.try(:username)}
    code(:link_to_profile) { |m| profile_path(m.profile) || '' }
  end
  # TODO: move stub for the pictures
  node(:image) {|obj| (imgs = obj.images).blank? ? '/assets/tmp/130x90.gif' : imgs.first.image_url(:chronicalthumb) }
end
