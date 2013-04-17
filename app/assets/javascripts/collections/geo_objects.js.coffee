#= require ../models/geo_object
class Smorodina.Collections.GeoObjects extends Backbone.Collection
  model: Smorodina.Models.GeoObject
  url: '/objects.json'
