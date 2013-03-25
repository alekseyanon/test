Smorodina.Utils.onSelector '.welcome', ->
  $('#mainSearchFieldInput').on 'focus', ->
    $('.how-to-search').addClass 'how-to-search_hidden'