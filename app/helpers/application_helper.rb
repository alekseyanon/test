module ApplicationHelper

  # Этот хелпер метод полностью заимствован из railscast'а
  # http://railscasts.com/episodes/196-nested-model-form-revised
  # метод рендерит ссылку на добавление шаблона
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_vote css_id, controller, tag
    prms= css_id.split('_')
    sign = prms[0]
    id = prms[-1]
    model = (prms - [sign, id]).join('_')
    link_to "#{sign}", "#rate", id: "vote-#{sign}-#{tag}", onclick: "to_vote('#{controller}#{model}', #{id}, '#{sign}', '#{tag}');"
  end

  def link_to_unvote css_id, controller, tag
    id = css_id.split('_')[-1]
    model = css_id.gsub('_'+id, '')
    link_to "unvote", "#rate", id: "vote-delete-#{tag}", onclick: "to_unvote('#{controller}#{model}', #{id}, '#{tag}');"
  end
end
