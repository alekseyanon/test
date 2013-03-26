#= require ../collections/landmarks
#= require ./base_view

class Smorodina.Views.LandmarkListEmpty extends Smorodina.Views.Base
  el: '#searchEmpty'
  init: ->
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
