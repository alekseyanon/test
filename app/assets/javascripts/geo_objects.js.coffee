#= require ./geo_objects_tmp
#= require ./collections/geo_objects

Smorodina.Pages.GeoObjects = ->

  $ ->
    new Smorodina.Views.GeoObjectList(collection:geo_objects)
    new Smorodina.Views.PageTitle(collection:geo_objects)
    new Smorodina.Views.SearchEmpty(collection:geo_objects)
    new Smorodina.Views.SearchResultsPanel(collection:geo_objects)
    new Smorodina.Views.SearchCategories(collection:geo_objects)
    new Smorodina.Views.Map()
    new Smorodina.Views.SearchForm()

    # TODO temporary solution
    geo_object_search()