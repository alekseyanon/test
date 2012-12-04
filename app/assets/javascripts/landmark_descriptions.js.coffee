# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$j = jQuery

apiKey='cda4cc8498bd4da19e72af2b606f5c6e'
tileUrlTemplate = "http://{s}.tile.cloudmade.com/#{apiKey}/997/256/{z}/{x}/{y}.png"

$j ->
  tmpx = $('.leaflet-edit-object').data("x") || 30
  tmpy = $('.leaflet-edit-object').data("y") || 56
  map = L.map('map').setView([tmpy, tmpx], 13)
  L.tileLayer(tileUrlTemplate,
    maxZoom: 18
  ).addTo map
  marker = L.marker([tmpy, tmpx]).addTo(map)