module ApplicationHelper
  def link_to_vote css_id, controller = ''
    sign = css_id.split('_')[0]
    model = css_id.split('_')[1]
    id = css_id.split('_')[2]
    link_to "#{sign}", "#", id: "vote-#{sign}", onclick: "to_vote(\'#{controller}#{model}\', #{id}, \'#{sign}\');"
  end
end
