window.load_objects_count = ->
  $.getJSON '/objects/count.json', (data) ->
    $('#objectsTotal').text data
