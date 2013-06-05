class Smorodina.Views.ChronicleIndex extends Backbone.View

  initialize: ->
    @collection.on 'sync', @render, @
    @collection.fetch reset: true

  render: ->
    @collection.each @render_chronicle_item
    @

  render_chronicle_item: (item) ->
    view = new Smorodina.Views.ChronicleItem(model: item)
    $('.test').append view.render().el
