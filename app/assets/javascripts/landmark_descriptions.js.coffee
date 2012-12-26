# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

apiKey = 'cda4cc8498bd4da19e72af2b606f5c6e'
tileUrlTemplate = "http://{s}.tile.cloudmade.com/#{apiKey}/997/256/{z}/{x}/{y}.png"

window.landmark_description_new = ->
  map = L.map('map')
  lg = L.layerGroup([]).addTo map
  L.tileLayer(tileUrlTemplate,
    maxZoom: 18
  ).addTo map
  map.setView [59.947, 30.255], 13
  xfield = $("#landmark_description_xld")
  yfield = $("#landmark_description_yld")
  popup = L.popup()
  map.on 'click', (e) ->
    xfield.val e.latlng.lng
    yfield.val e.latlng.lat
    $.getJSON '/landmark_descriptions/nearest_node.json',
      x: e.latlng.lng
      y: e.latlng.lat
      (data) -> 
        popup
          .setLatLng(data)
          .setContent("Place for object marker")
          .openOn(map)

window.landmark_description_edit = ->
  map = L.map('map')
  lg = L.layerGroup([]).addTo map
  L.tileLayer(tileUrlTemplate,
    maxZoom: 18
  ).addTo map
  leafletData = $ '.leaflet-edit-object'
  x = leafletData.data('x') || 30
  y = leafletData.data('y') || 56
  map.setView [y, x], 13
  L.marker([y, x]).addTo map
  xfield = $("#landmark_description_xld")
  yfield = $("#landmark_description_yld")
  tmpx = 0
  tmpy = 0
  popup = L.popup()
  map.on 'click', (e) ->
    tmpx = e.latlng.lng
    tmpy = e.latlng.lat
    xfield.val tmpx
    yfield.val tmpy
    popup
      .setLatLng(e.latlng)
      .setContent("New place of object")
      .openOn(map)

window.landmark_description_show = ->
  map = L.map('map')
  lg = L.layerGroup([]).addTo map
  L.tileLayer(tileUrlTemplate,
    maxZoom: 18
  ).addTo map
  leafletData = $ '.leaflet-edit-object'
  x = leafletData.data('x') || 30.233
  y = leafletData.data('y') || 59.947
  map.setView [y, x], 13
  L.marker([y, x]).addTo map

window.landmark_description_search = ->    
  map = L.map('map')
  lg = L.layerGroup([]).addTo map
  L.tileLayer(tileUrlTemplate,
    maxZoom: 18
  ).addTo map

  lastBounds = null

  setFields = (x,y,r) ->
    $("#x").val x
    $("#y").val y
    $("#r").val r

  getCurrentlyVisibleIDs = ->
    parseInt($(e).attr 'id') for e in $('#search-results').children('.landmark-search-result')

  addResultBlock = (landmark) ->
    $('#search-results').append JST['landmark']({landmark:landmark})

  applySearch = (data) -> #TODO refactor
    currentIDs = getCurrentlyVisibleIDs()
    newIDs = (desc.id for desc in data)
    IDsToRemove = _.without(currentIDs, newIDs...)
    IDsToAdd = _.without(newIDs, currentIDs...)
    addResultBlock(desc) for desc in data when _.contains(IDsToAdd, desc.id)
    $("##{id}").remove() for id in IDsToRemove
    lg.clearLayers()
    L.marker(desc.describable.osm.latlon).addTo(lg) for desc in data

  updateQuery = ->
    bounds = map.getBounds()
    return if bounds.equals lastBounds
    lastBounds = bounds
    center = map.getCenter()
  #  radius = center.distanceTo new L.LatLng bounds.getNorthEast().lat, center.lng
    radius = Math.abs(center.lat - bounds.getNorthEast().lat) / 0.01745329251994328 / 60.0 #SRID 4326
    text = $('#text').val()
    setFields center.lng, center.lat, radius
    $.getJSON '/landmark_descriptions.json',
      query:
        x: center.lat
        y: center.lng
        r: radius
        text: text
      (data) -> applySearch data

  map.on 'load', ->
    map.on 'zoomend', (e) ->
      updateQuery()
    map.on 'moveend', (e) ->
      updateQuery()
    updateQuery()
  $('#text').change ->
    lastBounds = null
    updateQuery()
  map.setView [59.939,30.341], 13
