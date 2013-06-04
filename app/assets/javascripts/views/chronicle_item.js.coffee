class Smorodina.Views.ChronicleItem extends Backbone.View
  tagName: 'li'

  render: ->
    console.log 'rendering single chronicle item'
    $(@el).html (@model.get('title'))
    this
