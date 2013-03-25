#= require ../models/event
class Smorodina.Collections.Events extends Backbone.Collection
  model: Smorodina.Models.Event
  url: 'events/search.json'
