class ProfilesController < InheritedResources::Base
  def my_avatar
    send_file "public/#{Image.last.image_url}",
              :type => 'image/jpeg',
              :disposition => 'inline'
  end
end
