#= require ../smorodina

class Smorodina.Routers.EventRouter extends Backbone.Router
  routes:
    'search': 'search'
    '': 'index'

  initialize: ->
    @initial = true

  index: ->
    Backbone.trigger 'eventsPageLoad', @initial
    @initial = false
