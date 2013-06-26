class Smorodina.Views.EventPlace extends Backbone.View
  template: JST['event_place']
  render: ->
    @$el.attr('id', @model.get 'id').html @template @model.toJSON()
    @
