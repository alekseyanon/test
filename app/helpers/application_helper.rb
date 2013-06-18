module ApplicationHelper

  # Этот хелпер метод полностью заимствован из railscast'а
  # http://railscasts.com/episodes/196-nested-model-form-revised
  # метод рендерит ссылку на добавление шаблона
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    link_to(name, '#', class: 'add_fields', data: {id: id, fields: fields.gsub('\n', '')})
  end

  def link_to_vote(obj, sign, voting_path, tag)
    id = obj.id
    model = obj.class.name.underscore.split('_').last
    link_id = tag.blank? ? "vote-#{sign}" : "vote-#{sign}-#{tag}"
    link_to "#{sign}", '#rate', id: link_id,
            onclick: "to_vote('#{voting_path}#{model}', #{id}, '#{sign}', '#{tag}');"
  end

  def link_to_unvote(obj, voting_path, tag)
    id = obj.id
    model = obj.class.name.underscore.split('_').last
    link_id = tag.blank? ? 'vote-delete' : "vote-delete-#{tag}"
    link_to 'unvote', '#rate', id: link_id,
            onclick: "to_unvote('#{voting_path}#{model}', #{id}, '#{tag}');"
  end

  def new_complaint_polymorphic_path votable
    new_polymorphic_path( if votable.is_a? Comment
                            [votable.commentable]
                          elsif votable.is_a? Runtip
                            [votable.geo_object ]
                          else
                            []
                          end + [votable, votable.complaints.build])
  end

  ### TODO: предполагаем что параметров может быть до 3-х
  ### votable - модель за которую голосуем
  ### *params может содержать тег модели за которую голосуем
  ### и формат данных(json)
  ### new_vote_polymorphic_path @geo_object
  ### new_vote_polymorphic_path @geo_object, format: :json
  ### new_vote_polymorphic_path @geo_object, 'tag'
  ### new_vote_polymorphic_path @geo_object, 'tag', format: :json
  def new_vote_polymorphic_path votable, *params
    options = {}
    args =  if votable.is_a? Comment
                   [votable.commentable]
                 elsif votable.is_a? Runtip
                   [votable.geo_object]
                 else
                   []
                 end  + [votable, votable.votes.build]
    params.compact.each do |p|
      options.merge!((p.is_a? String) ? {voteable_tag: p} : p)
    end
    polymorphic_path args, options
  end

  def ip_location ip
    (@sx_geo ||= SxGeo.new).get(ip)
  end

  def destroy_vote_polymorphic_path votable
    new_vote_polymorphic_path(votable).strip + "/#{Vote.first.id}"
  end
end
