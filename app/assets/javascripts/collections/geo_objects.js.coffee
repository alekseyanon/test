#= require ../models/geo_object
class Smorodina.Collections.GeoObjects extends Backbone.Collection

  model: Smorodina.Models.GeoObject

  url: '/api/objects.json'

  sortCollection: ->

  fetch: (options = {}) ->
    @directResults = options['direct_search']
    super(options)

  hasExactlyOneDirectResult: ->
    @directResults and @length == 1

  applyFilter: (tag) ->
    if tag == 'all'
      geo_object.trigger( 'filterApplied', true ) for geo_object in @models
    else
      active_objects     = @tagged(tag)
      inactive_objects   = _.difference @models, active_objects
      geo_object.trigger( 'filterApplied', true )  for geo_object in active_objects
      geo_object.trigger( 'filterApplied', false ) for geo_object in inactive_objects

  countTags: ->
    tags = _.map ['sightseeing', 'lodging', 'food', 'activities', 'infrastructure'], (tag) =>
             name  : tag
             count : @tagged(tag).length
    tags.push( name : 'all', count : @models.length )
    tags
  
  tagged: (tag) ->
    @filter (geo_object) -> _.include( geo_object.get('tag_list'), tag )
