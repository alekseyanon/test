module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_vote css_id, controller = ''
    sign, model, id = css_id.split('_')[0..2]
    link_to "#{sign}", "#", id: "vote-#{sign}", onclick: "to_vote(\'#{controller}#{model}\', #{id}, \'#{sign}\');"
  end
end
