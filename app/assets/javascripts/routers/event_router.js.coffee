#= require ../smorodina

class Smorodina.Routers.EventRouter extends Backbone.Router
  routes:
    'week/:date': 'changeDate'
    '': 'index'
  changeDate: (week) ->
    console.log week

  index: ->
    console.log 'index'
