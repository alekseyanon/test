class Smorodina.Views.Category extends Backbone.View
  tagName: 'li'
  template: JST['category'],
  events:
    'click': 'toggle'

  initialize: ->
    _.bindAll(@)
    @model.on 'change:visibility', @toggleVisibility
    @model.on 'change:state', @toggleState

  render: ->
    @$el.append @template @model.toJSON()
    @model.set('visibility', false)
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
    @model.kickOff()
    e.stopPropagation()

  toggleState: (model)->
    new_state = model.get('state')
    for state in ['bordered', 'semi-selected', 'selected', 'deselected']
      @$el.toggleClass state, new_state == state

  toggleVisibility: (model, val)->
    @$el.toggle val 
