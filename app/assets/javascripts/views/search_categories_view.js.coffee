#= require ../collections/geo_objects
#= require ./base_view

class Smorodina.Views.SearchCategories extends Smorodina.Views.Base
  el: '#searchCategories'
  initialize: ->
    super()
    @collection.on 'reset', @render
    @collection.on 'request', @onRequest

  render: ->
    if @collection.length then @show() else @hide()

  onRequest: ->
    @hide()
