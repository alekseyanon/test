window.Smorodina =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Utils:
    onSelector: (selector, callback) ->
      callback() if $(selector).length

    onRoute: (routes, callback) ->
      findInLocationUrl = (str) ->
        document.location.pathname.indexOf(str) != -1

      if typeof routes == 'string' and findInLocationUrl(routes)
        callback()
      else if routes instanceof Array
        callback() if _.find routes, findInLocationUrl