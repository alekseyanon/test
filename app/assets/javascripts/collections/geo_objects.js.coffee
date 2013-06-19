#= require ../models/geo_object
class Smorodina.Collections.GeoObjects extends Backbone.Collection
  model: Smorodina.Models.GeoObject
  url: '/api/objects.json'
  sortCollection: ->
  fetch: (options) ->
    @directResults = options['direct_search']
    super(options)
  hasExactlyOneDirectResult: ->
  	@directResults and @length == 1
