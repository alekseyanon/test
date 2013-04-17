#= require ./routers/global_router
#= require ./geo_objects

Smorodina.Pages.Index = ->

  # TODO temporary solution.
  # in future index page and landmarks page will have their own init code
  Smorodina.Pages.GeoObjects()

  $ ->
    new Smorodina.Views.SearchFilter

    $('#mainSearchFieldInput').on 'focus', ->
      $('.how-to-search').addClass 'how-to-search_hidden'
