class Smorodina.Views.GeoObjectPlace extends Smorodina.Views.Base
  template: JST['geo_object_place']
  className: 'smorodina-item'
  events: 
    'click .smorodina-item__comments a'   : 'comment'
  comment: (e) ->
    if !@is_authorized()
      e.preventDefault()
    
  render: ->
    @$el.attr('id', @model.get 'id').html @template @model.toJSON()
    @
