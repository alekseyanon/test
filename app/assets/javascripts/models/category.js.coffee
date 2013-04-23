class Smorodina.Models.Category extends Backbone.Model

  defaults:
    selected: false
    semiSelected: false
    selectedChildren: 0

  initialize: ->
    _.bindAll(@)
    @collection.on 'reset', @getParent
    @collection.on 'reset', @getChildren

  getParent: ->
    parentModel = @collection.findWhere(id: @get('parent_id'))
    if parentModel then parentModel.on 'change:selected', @updateByParent

  getChildren: ->
    children = @get('children')
    if children.length then _.each children, @_getChildren

  _getChildren: (childId) ->
    child = @collection.findWhere(id: childId)
    child.on 'change:selected', @updateByChildren

  updateByParent: (parentModel, selected, options) ->
    if !options.preventCapture then @set('selected', selected)

  updateByChildren: (childModel, selected, options) ->
    if !options.preventBubble
      counter = if selected then 1 else -1
      selectedChildren = @get('selectedChildren') + counter
      semiSelected = Boolean(selectedChildren) && @get('children').length != selectedChildren

      @set(selectedChildren: selectedChildren)
      @set(semiSelected: semiSelected)
      #@set({ selected: false }, { preventCapture: true, preventBubble: true }) if semiSelected

      console.log @get('name'), @get('selected'), semiSelected, selectedChildren, @get('children').length
