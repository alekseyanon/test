#= require ./routers/global_router
#= require ./geo_objects

Smorodina.Pages.Index = ->

  $ ->
    new Smorodina.Views.SearchFilter
    new Smorodina.Views.Map

    # TODO temporary solution
    geo_object_search()

    $('#mainSearchFieldInput').on 'focus', ->
      $('.how-to-search').addClass 'how-to-search_hidden'
