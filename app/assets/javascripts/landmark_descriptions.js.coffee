#= require ./landmark_descriptions_tmp
#= require ./collections/landmarks

Smorodina.Pages.LandmarkDescriptions = ->

  $ ->
    new Smorodina.Views.LandmarkList(collection:landmarks)
    new Smorodina.Views.PageTitle(collection:landmarks)
    new Smorodina.Views.LandmarkListEmpty(collection:landmarks)
    new Smorodina.Views.SearchPanel(collection:landmarks)
    new Smorodina.Views.SearchCategories(collection:landmarks)
    new Smorodina.Views.Map()
    new Smorodina.Views.SearchForm()

    # TODO temporary solution
    landmark_description_search()