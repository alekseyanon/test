class Smorodina.Views.Base extends Backbone.View
  initialize: ->
    _.bindAll(@)
    if typeof @init == 'function' then @init()

  show: ->
    @$el.show()

  hide: ->
    @$el.hide()