#= require ./base_view

class Smorodina.Views.SearchFetch extends Smorodina.Views.Base
  el: '#searchResultsFetch'
  initialize: ->
    super()
    @collection.on 'reset', @render
    @collection.on 'request', @onRequest

  render: ->
    if @collection.length then @show() else @hide()

  onRequest: ->
    @hide()
