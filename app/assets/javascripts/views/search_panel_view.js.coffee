#= require ../collections/landmarks
#= require ././base_view

class Smorodina.Views.SearchPanel extends Smorodina.Views.Base
  el: '#searchResultsPanel'
  init: ->
    @collection.on 'reset', @render
    @collection.on 'request', @onRequest

  render: ->
    if @collection.length then @show() else @hide()

  onRequest: ->
    @hide()
