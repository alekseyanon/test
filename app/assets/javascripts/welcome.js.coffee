Smorodina.Pages.Index = ->

  # TODO temporary solution
  Smorodina.Pages.LandmarkDescriptions();

  $('#mainSearchFieldInput').on 'focus', ->
    $('.how-to-search').addClass 'how-to-search_hidden'
