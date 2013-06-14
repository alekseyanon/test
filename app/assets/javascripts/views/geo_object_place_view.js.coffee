class Smorodina.Views.GeoObjectPlace extends Backbone.View
  template: JST['geo_object_place']
  className: 'smorodina-item'
  render: ->
    @$el.attr('id', @model.get 'id').html @template @model.toJSON()
    this
