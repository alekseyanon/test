#= require ./routers/global_router
#= require ./landmark_descriptions

Smorodina.Pages.Index = ->

  $ ->
    new Smorodina.Views.SearchFilter
    new Smorodina.Views.Map

    # TODO temporary solution
    landmark_description_search()

    $('#mainSearchFieldInput').on 'focus', ->
      $('.how-to-search').addClass 'how-to-search_hidden'
