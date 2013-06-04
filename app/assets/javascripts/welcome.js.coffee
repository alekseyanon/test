#= require routers/global_router
#= require collections/categories

Smorodina.Pages.Index = ->

  categories = new Smorodina.Collections.Categories
  collect = new Smorodina.Collections.ChronicleItems()
  collect.fetch({reset: true})

  $ ->
    new Smorodina.Views.SearchFilter
    new Smorodina.Views.Categories(collection: categories)
    new Smorodina.Views.Map

    view = new Smorodina.Views.ChronicleIndex(collection: collect)
    $('.chronicle').html(view.render().el)

    # TODO temporary solution
    geo_object_search()

    $('#mainSearchFieldInput').on 'focus', ->
      $('.how-to-search').addClass 'how-to-search_hidden'
