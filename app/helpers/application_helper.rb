module ApplicationHelper
  def link_to_vote text, controller = ''
    link_to "#{text.split('_')[0]}", "#", id: "vote-#{text.split('_')[0]}", onclick: "to_vote(\'#{controller}#{text.split('_')[1]}\', #{text.split('_')[2]}, \'#{text.split('_')[0]}\');"
  end
end
