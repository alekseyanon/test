#= require ../models/event
class Smorodina.Collections.Events extends Backbone.Collection
  model: Smorodina.Models.Event
  initialize: ->
    this.on 'reset', @onReset
  url: 'events/search.json'
  onReset: ->
    console.log 'hello'
