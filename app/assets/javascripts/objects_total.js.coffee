window.load_objects_count = ->
  $.getJSON '/landmark_descriptions/count.json', (data) ->
    $('#objets_total').text data
