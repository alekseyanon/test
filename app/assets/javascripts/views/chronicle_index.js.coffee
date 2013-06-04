class Smorodina.Views.ChronicleIndex extends Backbone.View
  events:
    'click .fetch-results__button': 'render'

  initialize: ->
    @collection.on('reset', @render, this)

  render: ->
    console.log 'rendering'
    #    $(@el).html(@template())
    @collection.each(@render_chronicle_item)
    this

  render_chronicle_item: (item) ->
    console.log 'rendering chronicle item'
    view = new Smorodina.Views.ChronicleItem(model: item)
    $('.temp_for-chronicle').append( view.render().el)
