#= require ./geo_objects_tmp
#= require ./collections/landmarks

Smorodina.Pages.GeoObjects = ->

  $ ->
    new Smorodina.Views.LandmarkList(collection:landmarks)
    new Smorodina.Views.PageTitle(collection:landmarks)
    new Smorodina.Views.LandmarkListEmpty(collection:landmarks)
    new Smorodina.Views.SearchPanel(collection:landmarks)
    new Smorodina.Views.SearchCategories(collection:landmarks)
    new Smorodina.Views.Map()
    new Smorodina.Views.SearchForm()

    # TODO temporary solution
    geo_object_search()
