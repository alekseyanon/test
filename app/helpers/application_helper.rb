module ApplicationHelper
  def link_to_vote css_id, controller = ''
    sign, model, id = css_id.split('_')[0..2]
    link_to "#{sign}", "#", id: "vote-#{sign}", onclick: "to_vote(\'#{controller}#{model}\', #{id}, \'#{sign}\');"
  end
end
