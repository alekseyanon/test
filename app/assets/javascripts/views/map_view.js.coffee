#= require ../collections/landmarks
#= require ./base_view

class Smorodina.Views.Map extends Smorodina.Views.Base
  el: '#mapContainer'
  events:
    'click #mapExpandButton': 'expand'
  initialize: ->
    super()
    Backbone.on 'MainSearchFormSubmit', @collapse
    @$mapContainer = @$ '#mapContainer'
    @$mapExpand = @$ '#mapExpand'

  expand: ->
    @$mapContainer.removeClass('map__container_collapsed')
    @$mapExpand.hide()

  collapse: ->
    @$mapContainer.addClass('map__container_collapsed')
    @$mapExpand.show()
