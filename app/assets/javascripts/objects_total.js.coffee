window.load_objects_count = ->
  $.getJSON '/objects/count.json', (data) ->
    $('#objets_total').text data
