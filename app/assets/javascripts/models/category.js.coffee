class Smorodina.Models.Category extends Backbone.Model

  defaults:
    selected: false
    semiSelected: false
    selectedChildren: 0

  initialize: ->
    _.bindAll(@)

  kickOff: ->
    selected = !@get('selected')
    @set('selected', selected)
    @updateChildren(selected)
    @updateParent(selected)

  setSelected: ->
    @set('selected' : true, 'semiSelected' : false )

  setSemiSelected: ->
    @set('semiSelected' : true, 'selected' : false)

  setUnselected: ->
    @set('semiSelected': false, 'selected' : false)

  updateParent: ->
    selected_siblings = _.filter @_siblings(), (s)-> s.get('selected')
    semi_selected_siblings = _.filter @_siblings(), (s)->s.get('semiSelected')
    parent = @_getParentModel()
    if parent
      if selected_siblings.length == @_siblings().length
        parent.setSelected()
      else if selected_siblings.length > 0 || semi_selected_siblings.length > 0
        parent.setSemiSelected()
      else 
        parent.setUnselected()
      parent.updateParent()

  
  #Если родителский элемент был выделен(не выделен), то дети будут тоже. 
  updateChildren: (value)->
    #Только что кликнутый родительский элемент не может быть полувыделенным, исправляем:
    @set('semiSelected', false)
    _.each @_getChildrenModels(), (c)=>
      c.set('selected', value)
      c.updateChildren(value)

  _siblings: ->
    if parent = @_getParentModel()
      parent._getChildrenModels()

  _getChildrenModels: ->
    _.map @get('children'), (childId) => 
      @collection.findWhere(id: childId)
  
  _getParentModel: ->
    @collection.findWhere(id: @get('parent_id'))

