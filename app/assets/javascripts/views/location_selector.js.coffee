#= require ./base_view

class Smorodina.Views.LocationSelector extends Smorodina.Views.Base
  initialize: ->
    super()
    @render()

    $lat = @$ '.location-selector__inputs .location-selector__inputs__lat'
    $lng = @$ '.location-selector__inputs .location-selector__inputs__lng'

    @mapView = new Smorodina.Views.ObjectsMap el: @$('.location-selector__map'), putMarker: true
    @mapView.on 'marker:put', =>
      coords = @mapView.markerCoords()
      $lat.valIfChanged coords.lat
      $lng.valIfChanged coords.lng

    $lat.add($lng).numeric().on 'keyup', =>
      coords = [
        parseFloat $lat.val() or 0
        parseFloat $lng.val() or 0
      ]
      @mapView.setMarkerCoords coords

    @aguSearch = new Smorodina.Views.AguSearch el: @$ '.location-selector__agu-search'
    @prevAgu = null
    @aguSearch.on 'selected', (data) =>
      if _.isEqual data, @prevAgu
        return
      @prevAgu = data
      @$('.location-selector__agu__title').text data.title
      @$('.location-selector__agu').css 'visibility', 'visible'
      if not data.map_bounds
        return
      @mapView.fitBounds data.map_bounds

  val: ->
    @mapView.markerCoords()

  render: ->
      @