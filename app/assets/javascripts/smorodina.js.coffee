window.Smorodina =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Utils:
    onSelector: (selector, callback) ->
      callback() if $(selector).length

    onRoute: (routes, callback) ->
      if typeof routes == 'string' and document.location.pathname.indexOf(routes) != -1
        callback()
      else if routes instanceof Array
        for route in routes
          if document.location.pathname.indexOf(route) != -1
            callback()
            return
