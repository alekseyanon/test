window.Smorodina =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Utils:
    onSelector: (selector, callback) ->
      if $(selector).length then callback()

    onRoute: (routes, callback) ->
      if typeof routes == 'string' and routes == document.location.pathname
        callback()
      else if routes instanceof Array
        for route in routes
          if route == document.location.pathname
            callback()
            return
