class Smorodina.Views.ChronicleItem extends Backbone.View
  tagname: 'div'
  template: JST['chronicle_day']

  initialize: ->
    _.bindAll(@)

  render: ->
    console.log 'rendering single chronicle item'
    @$el.append @template chronicle_item: @model
    @
