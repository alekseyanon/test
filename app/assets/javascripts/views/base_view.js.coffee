class Smorodina.Views.Base extends Backbone.View
  initialize: ->
    _.bindAll(@)

  show: ->
    @$el.show()

  hide: ->
    @$el.hide()
