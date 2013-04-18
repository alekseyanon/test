class Smorodina.Views.GeoObject extends Backbone.View
  template: JST['geo_object']
  className: 'smorodina-item'
  render: ->
    @$el.attr('id', @model.get 'id').html @template @model.toJSON()
    this
