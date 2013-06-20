#= require collections/geo_objects

Smorodina.Pages.PlaceShow = ->
  $ ->
    @agc_id = $('.place_show_page').attr 'data-agc'
    @agu_id = $('.place_show_page').attr 'data-agu'
    @objects_collection = new Backbone.Collection @model, url: "/objects.json?query[agc_id]=#{@agc_id}"
    @events_collection = new Backbone.Collection @model, url: "/api/events/search?place_id=#{@agu_id}"
    new Smorodina.Views.GeoObjectPlaceList(collection:@objects_collection)
    new Smorodina.Views.EventPlaceList(collection:@events_collection)
