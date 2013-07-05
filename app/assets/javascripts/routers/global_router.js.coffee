#= require ../smorodina
#= require ../collections/geo_objects

class Smorodina.Routers.Global extends Backbone.Router
  routes:
    'events(/search)': Smorodina.Pages.Events
    'objects/search':  'objects_search'
    '(objects/:object_id)/images/:image_id': 'object_image_show'
    'objects/:id/images': 'object_images_index'
    'objects/new': 'object_new'
    'objects/:id': 'object_show'
    'objects(/*path)': 'objects_index' #TODO remove temporary route, objects index should go
    'places/:id': 'place_show'
    '': 'index'
  object_image_show: ->
    $ ->
      new view for view in [Smorodina.Views.ImageShow
                            Smorodina.Views.Comments
                            Smorodina.Views.Votings]

  object_images_index: ->
    $ ->
      new Smorodina.Views.ImagesIndex

  object_show: (id)->
    $ ->
      new Smorodina.Views.ObjectShow object_id: id

  object_new: ->
    $ ->
      new Smorodina.Views.CategoriesGeoCreation(collection: new Smorodina.Collections.Categories)


  objects_search: ->
    $ ->
      new view(collection:geo_objects) for view in [Smorodina.Views.GeoObjectList
                                                    Smorodina.Views.PageTitle
                                                    Smorodina.Views.SearchEmpty
                                                    Smorodina.Views.SearchResultsPanel
                                                    Smorodina.Views.SearchCategories]
      geo_object_search()

  objects_index: ->
    console.log "objects_index"

  place_show: (id) ->
    $ ->
      @agc_id = $('.place_show_page').attr 'data-agc'
      @agu_id = $('.place_show_page').attr 'data-agu'
      @objects_collection = new Backbone.Collection @model, url: "/objects.json?query[agc_id]=#{@agc_id}"
      @events_collection = new Backbone.Collection @model, url: "/api/events/search?place_id=#{@agu_id}"
      new Smorodina.Views.GeoObjectPlaceList(collection:@objects_collection)
      new Smorodina.Views.EventPlaceList(collection:@events_collection)

  index: ->
    chronicle_items = new Smorodina.Collections.ChronicleItems
    categories = new Smorodina.Collections.Categories
    $ ->
      new Smorodina.Views.SearchFilter
      new Smorodina.Views.CategoriesWelcome collection: categories
      new Smorodina.Views.Map
      new Smorodina.Views.Chronicle collection: chronicle_items
      # TODO temporary solution
      geo_object_search()
      $('#mainSearchFieldInput').on 'focus', ->
        $('.how-to-search').addClass 'how-to-search_hidden'
