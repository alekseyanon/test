window.Smorodina =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Pages: {}
  Utils:
    History:
      stop: ->
        Backbone.history.stop()
        Backbone.history = new Backbone.History;
