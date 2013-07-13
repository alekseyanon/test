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

  putSelectionMarker: (latlng) ->
    if not @options.putMarker
      return
    map = @map
    latlng ?= @centerCoords()
    if not @marker
      markerLg = L.layerGroup([]).addTo map
      @marker = L.marker(latlng, icon: @categoryIconMap.selection, draggable: true).addTo markerLg
      @marker.on 'drag', =>
        @trigger 'marker:put'
      @$('.objects-map__hint').css 'visibility', 'hidden'
    else
      @marker.setLatLng latlng
    @$('.leaflet-control-container').addClass 'has-marker'
    @trigger 'marker:put'


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
    @$container = $c = @$ '.objects-map__content'
    id = 'map' + "#{Math.random()}"[2..]
    $c.attr 'id', id

    mapLayer = L.tileLayer(Smorodina.Config.urlTemplate, maxZoom: @maxZoom)
    satLayer = L.tileLayer(Smorodina.Config.urlTemplateSat, subdomains: '1234', maxZoom: @maxZoom)

    @map = map = L.map id, { scrollWheelZoom: false, layers: [satLayer, mapLayer] }
    @lg = lg = L.layerGroup([]).addTo map

    map.removeControl map.zoomControl
    @initSelectionMarkerControl()
    @initMyLocationControl()
    map.addControl L.control.zoom()
    L.control.layers({'Спутник': satLayer, 'Карта': mapLayer}, {}, {collapsed: false}).addTo(map);

  setupMap: ->
    map = @map
    lg = @lg
    lastBounds = null
    prevMarkers = {}

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
      #lg.clearLayers()
      # store markers that we have on map right now
      newMarkers = {}
      markerOpacity = if @options.putMarker then 0.7 else 1.0
      @collection.forEach (l) ->
        latlon = l.get 'latlon'
        if latlon of prevMarkers
          newMarkers[latlon] = prevMarkers[latlon]
        return
        icon   = categoryIconMap[l.get('tag_list')[0]]
        newMarkers[latlon] = m = L.marker(latlon, icon: icon, opacity: markerOpacity, riseOnHover: true).addTo lg
        m.bindPopup JST['map_object_popup'](l),
          autoPan: true
          offset: new L.Point(100, 100, true)
      # delete invisible markers
      for latlon, m of prevMarkers
        if not latlon of newMarkers
          map.removeLayer(m)
      prevMarkers = newMarkers

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

    map.on 'load', ->
      map.on 'zoomend', updateQuery
      map.on 'moveend', updateQuery
      updateQuery()

    map.setView @defaultCoords, @defaultZoom

  centerCoords: ->
    @map.getCenter()

  setCenterCoords: (coords, zoom) ->
    @map.setView coords, zoom or @map.getZoom()

  fitBounds: (bounds) ->
    if not bounds
      return
    @map.fitBounds bounds

  markerCoords: ->
    @marker?.getLatLng()

  setMarkerCoords: (latlng) ->
    if not @options.putMarker
      return
    if not @marker
      @putSelectionMarker(latlng)
    else
      @marker.setLatLng latlng
    if not @map.getBounds().contains(latlng)
      @map.setView latlng, @map.getZoom()
    @trigger 'marker:put'

  render: ->
    if not @options.putMarker
      @$('.objects-map__hint').remove()
    @initMap()
    @setupMap()
    @
