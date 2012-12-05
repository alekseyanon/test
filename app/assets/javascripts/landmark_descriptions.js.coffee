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

  getCurrentlyVisibleIDs = ->
    parseInt($j(e).attr 'id') for e in $j('#search-results').children('.landmark-search-result')

  addResultBlock = (description) ->
#    console.log "addResultBlock : #{description.id}"
#    console.log "addResultBlock : ", description
#    console.log description.title
    block = $j('#landmark-template').clone()
    block.attr "id", description.id
#    console.log block
#    console.log $j(block).find('.landmark-title').text()
    $j(block).find('.landmark-title').text(description.title)
#    $j(block).find('.landmark-tags').val description['tags']
    $j('#search-results').append block
    $j(block).show()
#    console.log getCurrentlyVisibleIDs()

  applySearch = (data) ->
#    console.log "applySearch"
#    console.log data
    currentIDs = getCurrentlyVisibleIDs()
#    console.log "current ids: ", currentIDs
    newIDs = (desc.id for desc in data)
#    console.log "new ids: ", newIDs
    IDsToRemove = _.without(currentIDs, newIDs...)
#    console.log "to remove : : ", IDsToRemove
    IDsToAdd = _.without(newIDs, currentIDs...)
#    console.log "to add : : ", IDsToAdd
    addResultBlock(desc) for desc in data when _.contains(IDsToAdd, desc.id) #TODO refactor
    $j("##{id}").remove() for id in IDsToRemove

  updateQuery = ->
    bounds = map.getBounds()
    return if bounds.equals lastBounds
#    console.log bounds
#    console.log lastBounds
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
