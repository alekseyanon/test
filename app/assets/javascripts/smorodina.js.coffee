window.Smorodina =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Pages: {}
  Utils:
    History:
      restart: (Router, options) ->
        options = _.extend({}, { pushState: true }, options)
        Backbone.history.stop()
        Backbone.history = new Backbone.History;
        new Router
        Backbone.history.start(options)
