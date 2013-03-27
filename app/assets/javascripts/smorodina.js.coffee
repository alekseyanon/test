window.Smorodina =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Utils:
    onSelector: (selector, callback) ->
      if $(selector).length then callback()

    onRoute: (routes, callback) ->
      if typeof routes == 'string' and document.location.pathname.indexOf(routes) isnt -1
        callback()
      else if routes instanceof Array
        for route in routes
          if document.location.pathname.indexOf(route) isnt -1
            callback()
            return
