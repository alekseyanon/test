class Smorodina.Views.Category extends Backbone.View
  tagName: 'li'
  template: JST['category'],
  events:
    'click': 'toggle'

  initialize: ->
    _.bindAll(@)
    @model.on 'change', @toggleSelected

  render: ->
    @$el.append @template @model.toJSON()
    subLevel = @model.collection.where(depth: @model.get('depth') + 1, parent_id: @model.get('id'))
    @renderSubLevel(subLevel) if subLevel.length
    @

  renderSubLevel: (subCategories) ->
    @$subList = $ '<ul>'
    _.each subCategories, @addOne
    @$el.append @$subList

  addOne: (subCategory) ->
    view = new Smorodina.Views.Category(model: subCategory)
    @$subList.append view.render().el

  toggle: (e) ->
    @model.set selected: !@model.get('selected')
    e.stopPropagation()

  toggleSelected: ->
    @$el.toggleClass 'semi-selected', @model.get('semiSelected')
    @$el.toggleClass('selected', @model.get('selected') && !@model.get('semiSelected'))
