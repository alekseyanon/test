#= require ../smorodina

class Smorodina.Routers.ChronicleRouter extends Backbone.Router
  routes:
    '': 'index'

  initialize: ->
    @collection = new Smorodina.Collections.ChronicleItems()
    @collection.fetch({reset: true})

  index: ->
    view = new Smorodina.Views.ChronicleIndex(collection: @collection)
    $('.chronicle').html(view.render().el)
