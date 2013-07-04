class Smorodina.Views.Category extends Backbone.View
  tagName: 'li'
  template: JST['category'],
  events:
    'click': 'toggle'

  initialize: ->
    _.bindAll(@)
    @model.on 'change:rootName', @setRootClass
    @model.on 'change:visibility', @toggleVisibility
    @model.on 'change:state', @toggleState
    @model.on 'actsAsLeaf', @applyLeafStyle

  render: ( visible = false )->
    @$el.append @template @model.toJSON()
    @$el.addClass "level_#{@model.get('depth')} #{@model.get('name')}"
    subLevel = @model.children()
    if subLevel.length
      @$el.addClass 'hasChildren'
      @renderSubLevel(subLevel)
    @

  renderSubLevel: (subCategories) ->
    @$subList = $ "<ul class='level_#{@model.get('depth')}_container'>"
    _.each subCategories, @addOne
    @$el.append @$subList

  addOne: (subCategory) ->
    view = new Smorodina.Views.Category(model: subCategory)
    @$subList.append view.render(@are_categories_visible_by_default).el

  toggle: (e) ->
    @model.kickOff()
    e.stopPropagation()

  toggleState: (model)->
    new_state = model.get('state')
    for state in ['bordered', 'semi-selected', 'selected', 'deselected']
      @$el.toggleClass state, new_state == state

  toggleVisibility: (model, val)->
    @$el.toggle val 
    
  setRootClass: ->
    @$el.addClass @model.get('rootName')

  applyLeafStyle: ->
    @$el.addClass 'leaf'
