# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# TODO temporary solution
window.landmarks = new Smorodina.Collections.Landmarks

initMap = ->
  map = L.map('map', { scrollWheelZoom: false })
  lg = L.layerGroup([]).addTo map
  L.tileLayer(Smorodina.Config.urlTemplate, {maxZoom: 18}).addTo map
  [map, lg]

showLatLng = (latlng) ->
  $("#landmark_description_xld").val latlng.lng
  $("#landmark_description_yld").val latlng.lat

getLatLng = ->
  d = $ '.leaflet-edit-object'
  new L.LatLng(d.data('y') || 59.947, d.data('x') || 30.233)

window.landmark_description_new = ->
  [map, _] = initMap()
  map.setView [59.947, 30.255], 13
  popup = L.popup()
  map.on 'click', (e) ->
    showLatLng e.latlng
    $.getJSON '/landmark_descriptions/nearest_node.json',
      x: e.latlng.lng
      y: e.latlng.lat
      (data) ->
        popup
          .setLatLng(data)
          .setContent("Place for object marker")
          .openOn(map)

window.landmark_description_edit = ->
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

window.landmark_description_show = ->
  [map, _] = initMap()
  latlng = getLatLng()
  map.setView latlng, 13
  L.marker(latlng).addTo map

window.landmark_description_search = ->
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
    landmarks.forEach (l) ->
      latlon = l.get('describable').osm.latlon
      if 'food' in l.get('tag_list')
        L.marker(latlon, {icon: coffeeIcon}).addTo lg
      else
        L.marker(latlon).addTo lg

  updateQuery = ->
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

    query.facets = facets

    landmarks.fetch
      reset: true
      query: query
      data: $.param
        query: query
      success: putMarkers

  resetBoundsAndSearch = ->
    lastBounds = null
    updateQuery()

  map.on 'load', ->
    map.on 'zoomend', updateQuery
    map.on 'moveend', updateQuery
    updateQuery()

  map.setView [59.939,30.341], 13 #SPB

  $labels = $('.search-categories').find('.search-category')

  $('.search-categories').on 'click', '.search-category', ->
    $label = $(this)
    facet = $label.data('facet')
    facets = if facet then [facet] else []

    $labels.removeClass('selected')
    $label.addClass('selected')

    resetBoundsAndSearch()

  $("#mainSearchButton").on 'click', resetBoundsAndSearch

  $searchField.on 'keydown', (e) ->
    if e.which is 13
      resetBoundsAndSearch()
