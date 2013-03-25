class Smorodina.Views.Event extends Backbone.View
  template: JST['event']
  className: 'smorodina-item'
  render: ->
    console.log(@model)
    @$el.attr('id', @model.get 'id').html @template @model.toJSON()
    this
