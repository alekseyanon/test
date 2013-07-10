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
      category.trigger( 'filterApplied', true ) for category in @models
    else
      to_be_shown  = @havingTag(tag)
      to_be_hidden = _.difference @models, to_be_shown
      category.trigger( 'filterApplied', true )  for category in to_be_shown
      category.trigger( 'filterApplied', false ) for category in to_be_hidden

  countTags: ->
    tags = _.map ['sightseeing', 'lodging', 'food', 'activities'], (tag) =>
             name  : tag
             count : @havingTag(tag).length
    tags.push( name : 'all', count : @models.length )
    tags
  
  havingTag: (tag) ->
    @filter (category) -> _.include( category.get('tag_list'), tag )
