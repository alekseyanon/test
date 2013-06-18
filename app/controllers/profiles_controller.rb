class ProfilesController < InheritedResources::Base
  def my_avatar
    send_file "public/#{current_user.profile.avatar_url}",
              type: 'image/jpeg',
              disposition: 'inline'
  end
end
