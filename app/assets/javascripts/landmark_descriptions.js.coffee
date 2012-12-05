# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$j = jQuery

apiKey='cda4cc8498bd4da19e72af2b606f5c6e'
tileUrlTemplate = "http://{s}.tile.cloudmade.com/#{apiKey}/997/256/{z}/{x}/{y}.png"

$j ->
  map = L.map('map')
  L.tileLayer(tileUrlTemplate,
    maxZoom: 18
  ).addTo map

  leafletData = $j '.leaflet-edit-object'
  if leafletData.length > 0 #TODO define current view in a more reliable way
    console.log 'single marker mode'
    x = leafletData.data('x') || 30
    y = leafletData.data('y') || 56
    map.setView [y, x], 13
    L.marker([y, x]).addTo map
    return
    
  lastBounds = null

  setFields = (x,y,r) ->
    $j("#x").val(x)
    $j("#y").val(y)
    $j("#r").val(r)

  applySearch = (data) ->
    console.log "applySearch"
    console.log data

  updateQuery = ->
    bounds = map.getBounds()
    return if bounds.equals lastBounds
    console.log bounds
    console.log lastBounds
    lastBounds = bounds
    center = map.getCenter()
    radius = (Math.abs(center.lat - bounds.getNorthEast().lat))*10 #TODO calculate real radius based on view
    text = $j("#text").val()
    setFields center.lng, center.lat, radius
    $j.getJSON '/landmark_descriptions.json',
      query:
        x: center.lat
        y: center.lng
        r: radius
        text: text
      (data) -> applySearch data

  $j.getJSON 'coordinates.json', (data) ->
    L.marker(p).addTo(map) for p in data
    map.setView data[0], 13
  map.on 'load', ->
    map.on 'zoomend', (e) ->
#      console.log e
      updateQuery()
    map.on 'moveend', (e) ->
#      console.log e
      updateQuery()
