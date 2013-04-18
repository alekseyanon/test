#= require ../collections/geo_objects
#= require ./base_view

class Smorodina.Views.GeoObjectListEmpty extends Smorodina.Views.Base
  el: '#searchEmpty'
  initialize: ->
    super()
    @$searchEmptyRequestText = @$ '#searchEmptyRequestText'
    @collection.on 'reset', @render
    @collection.on 'request', @onRequest

  onRequest: (collection, xhr, options) ->
    @hide()
    @requestText = options.query.text

  render: ->
    unless @collection.length
      @$searchEmptyRequestText.html(@requestText)
      @show()
