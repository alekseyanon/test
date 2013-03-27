window.Smorodina =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Utils:
    on: (selector, callback) ->
      $ ->
        if $(selector).length then callback()
