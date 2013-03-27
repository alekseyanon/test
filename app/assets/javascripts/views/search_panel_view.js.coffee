#= require ../collections/landmarks
#= require ./base_view

class Smorodina.Views.SearchPanel extends Smorodina.Views.Base
  el: '#searchPanel'
  initialize: ->
    super()
    @collection.on 'reset', @render
    @collection.on 'request', @onRequest

  render: ->
    if @collection.length then @show() else @hide()

  onRequest: ->
    @hide()
