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
    id = 'map' + "#{Math.random()}"[2..]
    @$el.attr 'id', id
    @map = map = L.map id, { scrollWheelZoom: false }
    @lg = lg = L.layerGroup([]).addTo map
    L.tileLayer(Smorodina.Config.urlTemplate, maxZoom: @maxZoom).addTo map

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

  setCenterCoords: (coords, zoom) ->
    @map.setView coords, zoom or @map.getZoom()

  markerCoords: ->
    @marker?.getLatLng()

  setMarkerCoords: (latlng) ->
    if not @options.putMarker
      return
    if not @marker
      @putSelectionMarker(latlng)
    else if not @marker.getLatLng().equals latlng
      @marker.setLatLng latlng
    if not @map.getBounds().contains(latlng)
      @map.setView latlng, @map.getZoom()
    @trigger 'marker:put'

  render: ->
    @initMap()
    @setupMap()
    @

class Smorodina.Views.AguSearch extends Smorodina.Views.Base
  url: '/api/agus/search.json'

  initialize: ->
    super()
    @render()

    @$input = @$ 'input.agu'
    @$input
      .autocomplete
        source: @findAgus
        autoFocus: true
        select: @_aguSelected
        change: @_aguSelected
    @$input.on 'keydown', (e) =>
      if e.which == 13
        $item = @$('.ui-autocomplete .ui-menu-item a.ui-state-focus')
        if not $item.length
          $item = @$('.ui-autocomplete .ui-menu-item:first a')
        @$input.val $item.text()
        @_aguSelected()
    @data = {}

  _handleSearchResult: (d) ->
    p = d.geom.match(/POLYGON \(\((.*)\)\)/)?[1]?.split(', ')
    zoom: null
    coords: (parseFloat(c) for c in p?[0]?.split(' ')).reverse()

  findAgus: (request, cb) ->
    $.ajax
      dataType: "json"
      url: @url
      data: { query: request.term }
      error: =>
        @data = {}
        cb []
      success: (data) =>
        @data = {}
        for d in data
          @data[d.title] = @_handleSearchResult d
        cb (d.title for d in data)

  _aguSelected: ->
    val = @val()
    @trigger 'selected', [val, @data[val]]

  val: ->
    @$input.val()

  render: ->
    @

class Smorodina.Views.LocationSelector extends Smorodina.Views.Base
  initialize: ->
    super()
    @render()

    $lat = @$ '.inputs .lat'
    $lng = @$ '.inputs .lng'

    @mapView = new Smorodina.Views.ObjectsMap el: @$('.location-selector__map__content'), putMarker: true
    @mapView.on 'marker:put', =>
      coords = @mapView.markerCoords()
      $lat.val coords.lat
      $lng.val coords.lng

    $lat.add($lng).numeric().on 'keyup', =>
      coords = [
        parseFloat $lat.val() or 0
        parseFloat $lng.val() or 0
      ]
      @mapView.setMarkerCoords coords

    @aguSearch = new Smorodina.Views.AguSearch el: @$ '.location-selector__agu-search'
    @prevAgu = null
    @aguSearch.on 'selected', (data) =>
      if data[0] == @prevAgu
        return
      @prevAgu = data[0]
      if not data[1]
        return
      @mapView.setCenterCoords data[1].coords, data[1].zoom

render: ->
    @