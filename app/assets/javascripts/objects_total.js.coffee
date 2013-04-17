window.load_objects_count = ->
  $.getJSON '/geo_objects/count.json', (data) ->
    $('#objets_total').text data
