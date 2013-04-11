#= require ./routers/global_router
#= require ./landmark_descriptions

Smorodina.Pages.Index = ->

  # TODO temporary solution.
  # in future index page and landmarks page will have their own init code
  Smorodina.Pages.LandmarkDescriptions()

  $ ->
    new Smorodina.Views.SearchFilter

    $('#mainSearchFieldInput').on 'focus', ->
      $('.how-to-search').addClass 'how-to-search_hidden'
