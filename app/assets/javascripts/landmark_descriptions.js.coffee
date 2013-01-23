# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

apiKey = 'cda4cc8498bd4da19e72af2b606f5c6e'
tileUrlTemplate = "http://{s}.tile.cloudmade.com/#{apiKey}/997/256/{z}/{x}/{y}.png"

initMap = ->
  map = L.map('map')
  lg = L.layerGroup([]).addTo map
  L.tileLayer(tileUrlTemplate,{maxZoom: 18}).addTo map
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
  landmarks = new Smorodina.Collections.Landmarks
  landmarksView = new Smorodina.Views.LandmarkList
    collection: landmarks

  putMarkers = ->
    lg.clearLayers()
    landmarks.forEach (l) ->
      L.marker(l.get('describable').osm.latlon).addTo lg

  $('#search-results').html landmarksView.render().el

  setFields = (x,y,r) ->
    $("#x").val x
    $("#y").val y
    $("#r").val r

  updateQuery = ->
    bounds = map.getBounds()
    return if bounds.equals lastBounds
    lastBounds = bounds
    center = map.getCenter()
  #  radius = center.distanceTo new L.LatLng bounds.getNorthEast().lat, center.lng
    radius = Math.abs(center.lat - bounds.getNorthEast().lat) / 0.01745329251994328 / 60.0 #SRID 4326
    text = $('#query').val()
    setFields center.lng, center.lat, radius
    query =
      x: center.lat
      y: center.lng
      r: radius
      text: text

    $facets = $('.search-filter-tabs').find('input').not('#all').filter(':checked')
    query.facets = [$facets.attr('id')] if $facets.length

    landmarks.fetch
      update: true
      data: $.param
        query: query
      success: putMarkers
  map.on 'load', ->
    map.on 'zoomend', updateQuery
    map.on 'moveend', updateQuery
    updateQuery()

  $("#search, .search-filter-tab").on 'click', ->
    lastBounds = null
    updateQuery()

  map.setView [59.939,30.341], 13 #SPB

  $('.search-filter-tab').on 'click', ->
    $(this)
      .siblings().removeClass('selected').end()
      .next('dd').andSelf().addClass('selected')



