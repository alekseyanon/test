class Smorodina.Views.Landmark extends Backbone.View
  template: JST['landmark']
  className: 'landmark-search-result'
  render: ->
    @$el.attr('id', @model.get 'id').html @template @model.toJSON()
