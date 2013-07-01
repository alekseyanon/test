#= require ./base_view

class Smorodina.Views.ObjectsMap extends Smorodina.Views.Base
  maxZoom: 18
  defaultZoom: 13
  defaultCoords: [59.939, 30.341] #SPB

  initialize: ->
    super()
    @collection = new Smorodina.Collections.GeoObjects
    @render()

  initMyLocationControl: ->
    showMyLocation = =>
      $.get '/objects/my_location', (data) =>
        if data
          @map.setView data.reverse(), @defaultZoom
          @coords = data

    L.MyLocationCommand = L.Control.extend
      options:
        position: 'topleft'
      onAdd: =>
        controlDiv = @$('.leaflet-control-zoom.leaflet-control')[0]
        controlUI = L.DomUtil.create 'a', 'leaflet-control-my-location', controlDiv
        controlUI.setAttribute 'href', '#'
        controlUI.title = 'Show my location'
        $(controlUI).click (e) ->
          e.preventDefault()
          showMyLocation()
        controlDiv

    commandControl = new L.MyLocationCommand()
    @map.addControl(commandControl)

  initMap: ->
    id = 'map' + "#{Math.random()}"[2..]
    @$el.attr 'id', id
    @map = map = L.map id, { scrollWheelZoom: false }
    @lg = lg = L.layerGroup([]).addTo map
    L.tileLayer(Smorodina.Config.urlTemplate, {maxZoom: @maxZoom}).addTo map
    @initMyLocationControl(map)

  setupMap: ->
    map = @map
    lg = @lg
    lastBounds = null
    facets = []

    categoryIconMap = {}
    for key in ['sightseeing', 'lodging', 'food', 'activities', 'infrastructure']
      categoryIconMap[key] = L.icon(
        iconUrl    : "/assets/icons/#{key}-marker.png"
        iconSize   : [61, 41])

    putMarkers = =>
      lg = @lg
      lg.clearLayers()
      @collection.forEach (l) ->
        latlon = l.get 'latlon'
        icon   = categoryIconMap[l.get('tag_list')[0]]
        L.marker(latlon, icon: icon).addTo lg

    collectDataForQuery = =>
      bounds = map.getBounds()
      return if bounds.equals lastBounds
      lastBounds = bounds

      bounding_box: map.getBounds().toBBoxString()
      #text: text
      facets: facets

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

    resetBoundsAndSearch = (opts={}) =>
      lastBounds = null
      updateQuery opts

    #resetSearchField = -> $searchField.val ''

    map.on 'load', ->
      map.on 'zoomend', updateQuery
      map.on 'moveend', updateQuery
      #resetSearchField()
      updateQuery()

    map.setView @defaultCoords, @defaultZoom

  render: ->
    @initMap()
    @setupMap()

class Smorodina.Views.LocationSelector extends Smorodina.Views.Base
  initialize: ->
    super()
    new Smorodina.Views.ObjectsMap el: @$ '.location-selector__map__content'
    @render()

  render: ->
    #@$el.text 'OK'
    @