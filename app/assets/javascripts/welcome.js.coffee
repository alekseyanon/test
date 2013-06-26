#= require routers/global_router
#= require collections/categories

Smorodina.Pages.Index = ->

  chronicle_items = new Smorodina.Collections.ChronicleItems
  categories = new Smorodina.Collections.Categories

  $ ->
    new Smorodina.Views.SearchFilter
    new Smorodina.Views.CategoriesWelcome(collection: categories)
    new Smorodina.Views.Map
    new Smorodina.Views.Chronicle(collection: chronicle_items)

    # TODO temporary solution
    geo_object_search()

    $('#mainSearchFieldInput').on 'focus', ->
      $('.how-to-search').addClass 'how-to-search_hidden'



