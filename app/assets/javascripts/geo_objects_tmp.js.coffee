# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# TODO temporary solution
window.geo_objects = new Smorodina.Collections.GeoObjects

initMap = ->
  map = L.map('map', { scrollWheelZoom: false })
  lg = L.layerGroup([]).addTo map
  L.tileLayer(Smorodina.Config.urlTemplate, {maxZoom: 18}).addTo map
  initMyLocationControl(map)
  [map, lg]

initMyLocationControl = (map)->
  $ ->
    L.MyLocationCommand = L.Control.extend(
      options:
        position: 'topleft'
      onAdd: ->
        controlDiv = $('.leaflet-control-zoom.leaflet-control')[0]
        controlUI = L.DomUtil.create 'a', 'leaflet-control-my-location', controlDiv
        controlUI.setAttribute 'href', '#'
        controlUI.title = 'Show my location'
        $(controlUI).click (e)->
          e.preventDefault()
          showMyLocation()
        controlDiv
    )
    commandControl = new L.MyLocationCommand()
    map.addControl(commandControl);

    showMyLocation = (_,e)->
      $.get 'objects/my_location', (data)->
        if data
          map.setView data.reverse(), 13
          $('.map').data coords: data

showLatLng = (latlng) ->
  $("#geo_object_xld").val latlng.lng
  $("#geo_object_yld").val latlng.lat

getLatLng = ->
  d = $ '.leaflet-edit-object'
  new L.LatLng(d.data('y') || 59.947, d.data('x') || 30.233)

window.geo_object_new = ->
  [map, _] = initMap()
  map.setView [59.947, 30.255], 13
  popup = L.popup()
  map.on 'click', (e) ->
    showLatLng e.latlng
    $.getJSON '/objects/nearest_node.json',
      x: e.latlng.lng
      y: e.latlng.lat
      (data) ->
        popup
          .setLatLng(data)
          .setContent("Place for object marker")
          .openOn(map)

window.geo_object_edit = ->
  [map, _] = initMap()
  latlng = getLatLng()
  map.setView latlng, 13
  L.marker(latlng).addTo map
  popup = L.popup()
  map.on 'click', (e) ->
    showLatLng e.latlng
    popup
      .setLatLng(e.latlng)
      .setContent("New place of object")
      .openOn(map)

window.geo_object_show = ->
  [map, _] = initMap()
  latlng = getLatLng()
  map.setView latlng, 13
  L.marker(latlng).addTo map

window.geo_object_search = ->
  [map, lg] = initMap()
  lastBounds = null
  facets = []
  $searchField = $('#mainSearchFieldInput')

  coffeeIcon = L.icon(
    iconUrl:    '/assets/coffee.png'
    iconSize:   [40, 40]
    iconAnchor: [20, 35])

  putMarkers = ->
    lg.clearLayers()
    geo_objects.forEach (l) ->
      latlon = l.get('latlon')
      if 'food' in l.get('tag_list')
        L.marker(latlon, {icon: coffeeIcon}).addTo lg
      else
        L.marker(latlon).addTo lg

  collectDataForQuery = ->
    bounds = map.getBounds()
    return if bounds.equals lastBounds
    lastBounds = bounds
    center = map.getCenter()
    #  radius = center.distanceTo new L.LatLng bounds.getNorthEast().lat, center.lng
    radius = Math.abs(center.lat - bounds.getNorthEast().lat) / 0.01745329251994328 / 60.0 #SRID 4326
    text = $searchField.val()

    query =  
      x: center.lat
      y: center.lng
      r: radius
      text: text
      facets: facets

  updateQuery = (opts = {})->
    if data = collectDataForQuery()
      geo_objects.fetch
        reset: true
        query: data
        data: $.param
          query: data
        success: putMarkers
        direct_search: opts.direct_search

  resetBoundsAndSearch = (opts = {})->
    lastBounds = null
    updateQuery opts

  resetSearchField = ->
    $searchField.val ''

  map.on 'load', ->
    map.on 'zoomend', updateQuery
    map.on 'moveend', updateQuery
    resetSearchField()
    updateQuery()

  map.setView [59.939,30.341], 13 #SPB

  categories_search = ->
    $labels = $('.search-categories').find '.search-category'
    $label = $(this)
    facet = $label.data('facet')
    facets = if facet then [facet] else []
    $labels.removeClass 'selected'
    $label.addClass 'selected'

  $('.search-categories').on 'click', '.search-category', ->
    categories_search()
    resetBoundsAndSearch direct_search : false

  $("#mainSearchButton").on 'click', ->
    resetBoundsAndSearch direct_search : true

  $searchField.on 'keydown', (e) ->
    if e.which is 13
      resetBoundsAndSearch direct_search : true
