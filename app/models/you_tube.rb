class YouTube < Video
  def html
    "<iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/#{id}\" frameborder=\"0\" allowfullscreen></iframe>"
  end
end