#= require routers/global_router
#= require collections/categories

Smorodina.Pages.Index = ->

  categories = new Smorodina.Collections.Categories
  chronicle_items = new Smorodina.Collections.ChronicleItems

  $ ->
    new Smorodina.Views.SearchFilter
    new Smorodina.Views.Categories(collection: categories)
    new Smorodina.Views.Map
    new Smorodina.Views.Chronicle(collection: chronicle_items)

    # TODO temporary solution
    geo_object_search()

    $('#mainSearchFieldInput').on 'focus', ->
      $('.how-to-search').addClass 'how-to-search_hidden'
