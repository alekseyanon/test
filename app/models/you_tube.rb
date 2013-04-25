class YouTube < Video
  def html
    "<iframe name='#{id}' width=\"420\" height=\"315\" src=\"http://www.youtube.com/embed/#{id}\" frameborder=\"0\" allowfullscreen></iframe>"
  end
end