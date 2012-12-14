# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


# TODO: can be deleted


apiKey = 'cda4cc8498bd4da19e72af2b606f5c6e'
tileUrlTemplate = "http://{s}.tile.cloudmade.com/#{apiKey}/997/256/{z}/{x}/{y}.png"

window.landmark = ->    
  map = L.map('map')
  lg = L.layerGroup([]).addTo map
  L.tileLayer(tileUrlTemplate,
    maxZoom: 18
  ).addTo map

  applySearch = (data) -> #TODO refactor
    lg.clearLayers()
    L.marker(desc).addTo(lg) for desc in data
    popup = L.popup()
      .setLatLng([59.935,30.339])
      .setContent("Search center")
      .openOn(map)

  updateQuery = ->
    $.getJSON '/landmarks.json',
      (data) -> applySearch data

  map.on 'load', ->
    updateQuery()
  map.setView [59.935, 30.339], 17
