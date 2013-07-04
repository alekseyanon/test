#= require ./base_view

class Smorodina.Views.ObjectsMap extends Smorodina.Views.Base
  maxZoom: 18
  defaultZoom: 13
  defaultCoords: [59.939, 30.341] #SPB

  initialize: () ->
    super()
    @collection = new Smorodina.Collections.GeoObjects
    @marker = null
    @render()

  putSelectionMarker: ->
    if not @options.putMarker
      return
    map = @map
    latlon = @centerCoords()
    if not @marker
      markerLg = L.layerGroup([]).addTo map
      @marker = L.marker(latlon, icon: @categoryIconMap.selection, draggable: true).addTo markerLg
      @marker.on 'drag', =>
        @trigger 'marker:drag'
    else
      @marker.setLatLng latlon
    @trigger 'marker:drag'


  initSelectionMarkerControl: ->
    if not @options.putMarker
      return

    L.SelectionMarkerCommand = L.Control.extend
      options:
        position: 'topleft'
      onAdd: =>
        controlUI = L.DomUtil.create 'a', 'leaflet-control-put-marker'
        controlUI.setAttribute 'href', '#'
        controlUI.title = 'Put marker'
        $(controlUI).click (e) =>
          e.preventDefault()
          @putSelectionMarker()
        controlUI

    commandControl = new L.SelectionMarkerCommand()
    @map.addControl(commandControl)

  initMyLocationControl: ->
    showMyLocation = =>
      $.get '/objects/my_location', (data) =>
        if data
          @map.setView data.reverse(), @defaultZoom

    L.MyLocationCommand = L.Control.extend
      options:
        position: 'topleft'
      onAdd: =>
        controlUI = L.DomUtil.create 'a', 'leaflet-control-my-location'
        controlUI.setAttribute 'href', '#'
        controlUI.title = 'Show my location'
        $(controlUI).click (e) ->
          e.preventDefault()
          showMyLocation()
        controlUI

    commandControl = new L.MyLocationCommand()
    @map.addControl(commandControl)

  initMap: ->
    id = 'map' + "#{Math.random()}"[2..]
    @$el.attr 'id', id
    @map = map = L.map id, { scrollWheelZoom: false }
    @lg = lg = L.layerGroup([]).addTo map
    L.tileLayer(Smorodina.Config.urlTemplate, {maxZoom: @maxZoom}).addTo map

    map.removeControl map.zoomControl
    @initSelectionMarkerControl()
    @initMyLocationControl()
    map.addControl L.control.zoom()

  setupMap: ->
    map = @map
    lg = @lg
    lastBounds = null

    @categoryIconMap = categoryIconMap = {}
    for key in ['sightseeing', 'lodging', 'food', 'activities', 'infrastructure']
      categoryIconMap[key] = L.icon(
        iconUrl    : "/assets/icons/#{key}-marker.png"
        iconSize   : [61, 41]
      )
    categoryIconMap['selection'] = L.icon(
      iconUrl    : "/assets/icons/selection-marker.png"
      iconSize   : [43, 52]

    )

    putMarkers = =>
      lg = @lg
      lg.clearLayers()
      markerOpacity = if @options.putMarker then 0.7 else 1.0
      @collection.forEach (l) ->
        latlon = l.get 'latlon'
        icon   = categoryIconMap[l.get('tag_list')[0]]
        L.marker(latlon, icon: icon, opacity: markerOpacity).addTo lg

    collectDataForQuery = =>
      bounds = map.getBounds()
      if bounds.equals lastBounds
        return
      lastBounds = bounds

      bounding_box: bounds.toBBoxString()

    updateQuery = (opts={}) =>
      if data = collectDataForQuery()
        delete data.bounding_box if opts.direct_search
        @collection.fetch
          reset: true
          query: data
          data: $.param
            query: data
          success: putMarkers
          direct_search: opts.direct_search

    resetBounds = (opts={}) =>
      lastBounds = null
      updateQuery opts

    map.on 'load', ->
      map.on 'zoomend', updateQuery
      map.on 'moveend', updateQuery
      updateQuery()

    map.setView @defaultCoords, @defaultZoom

  centerCoords: ->
    @map.getCenter()

  markerCoords: ->
    @marker?.getLatLng()

  setMarkerCoords: (latlon) ->
    if not @options.putMarker
      return
    if not @marker
      @putSelectionMarker()
    @marker.setLatLng latlon
    if not @map.getBounds().contains(latlon)
      @map.setView latlon, @map.getZoom()

  render: ->
    @initMap()
    @setupMap()

class Smorodina.Views.LocationSelector extends Smorodina.Views.Base
  initialize: ->
    super()
    @render()
    @mapView = new Smorodina.Views.ObjectsMap el: @$('.location-selector__map__content'), putMarker: true
    @mapView.on 'marker:put', => # update text fields


  render: ->
    @