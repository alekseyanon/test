# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$j = jQuery

apiKey='cda4cc8498bd4da19e72af2b606f5c6e'
tileUrlTemplate = "http://{s}.tile.cloudmade.com/#{apiKey}/997/256/{z}/{x}/{y}.png"

$j ->
  map = L.map('map').setView([51.505, -0.09], 13)
  L.tileLayer(tileUrlTemplate,
    maxZoom: 18
  ).addTo map
  marker = L.marker([51.5, -0.09]).addTo(map)