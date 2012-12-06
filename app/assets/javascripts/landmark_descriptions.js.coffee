# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

apiKey='cda4cc8498bd4da19e72af2b606f5c6e'
tileUrlTemplate = "http://{s}.tile.cloudmade.com/#{apiKey}/997/256/{z}/{x}/{y}.png"

$ ->
  map = L.map('map')
  lg = L.layerGroup([]).addTo map
  L.tileLayer(tileUrlTemplate,
    maxZoom: 18
  ).addTo map

  leafletData = $ '.leaflet-edit-object'
  if leafletData.length > 0 #TODO define current view in a more reliable way
    console.log 'single marker mode'
    x = leafletData.data('x') || 30
    y = leafletData.data('y') || 56
    map.setView [y, x], 13
    L.marker([y, x]).addTo map
    return
    
  lastBounds = null

  setFields = (x,y,r) ->
    $("#x").val x
    $("#y").val y
    $("#r").val r

  getCurrentlyVisibleIDs = ->
    parseInt($(e).attr 'id') for e in $('#search-results').children('.landmark-search-result')

  addResultBlock = (description) ->
    block = $('#landmark-template').clone()
    block.attr "id", description.id
    $(block).find('.landmark-title').text description.title
    $(block).find('.landmark-tags').text description.tag_list
    $('#search-results').append block
    $(block).show()

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
#    radius = center.distanceTo new L.LatLng bounds.getNorthEast().lat, center.lng
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
