class Smorodina.Models.Category extends Backbone.Model

  defaults:
    selected: false
    semiSelected: false
    selectedChildren: 0

  initialize: ->
    _.bindAll(@)

  kickOff: ->
    @toggleSelected()
    wasSelected = @get('selected')
    wasSemiSelected = @get('semiSelected')
    @diselectSiblings() if wasSelected

    @updateParent()
    
    _.each @_getVisibleChildrenModels(), (c)=>
      c.updateChildren 'semiSelected', wasSelected 
      c.updateChildren 'selected', false
      c.updateChildren 'bordered', false


  cleanUnwantedStates: (exception)->
    h = {}
    for state in ['selected', 'semiSelected', 'bordered']
      if state != exception
        h[state] = false
        @set h

  toggleSelected: ->
    @set 'selected' : !@get('selected'), 'semiSelected' : false, 'bordered' : false

  setSelected: ->
    @set 'selected' : true, 'semiSelected' : false, 'bordered' : false

  setSemiSelected: ->
    @set 'semiSelected' : true, 'selected' : false, 'bordered' : false

  setUnselected: ->
    @set 'semiSelected': false, 'selected' : false , 'bordered' : false

  setBordered: ->
    @set 'selected' : false, 'semiSelected' : false, 'bordered' : true

  diselectSiblings: ->
    _.each @_siblings(true), (s)=>
      if _.all(s._getChildrenModels('full_tree' : true).concat(s), (c)=> !c.get('selected') and !c.get('bordered'))
        s.updateChildren 'semiSelected', false 
  


  updateParent: ->
    selected_siblings      = _.filter @_siblings(), (s)-> s.get('selected')
    semi_selected_siblings = _.filter @_siblings(), (s)-> s.get('semiSelected')
    parent = @_getParentModel()
    if _.any(@_siblings(), (s)-> s.get('bordered'))
      semiSelectedSiblings = _.filter @_siblings(true), (s)-> s.get('semiSelected') 
      for s in semiSelectedSiblings
        s.updateChildren('semiSelected', false)

    if parent
      if selected_siblings.length + semi_selected_siblings.length == @_siblings().length
        parent.setSelected()
      else if _.filter(@_siblings(), (s)-> s.get('semiSelected') or s.get('selected') or s.get('bordered')).length > 0
        parent.setBordered()
      else 
        parent.setUnselected()
      parent.updateParent()

  updateChildren: (state, value)->
    console.log  state, value
    @set state, value
    _.each @_getVisibleChildrenModels(), (c)=>
      c.updateChildren state, value
  
  #При клике по категории в виде кнопки
  updateByEmblem: (should_be_visible)->
    @setSemiSelected() if should_be_visible
    @set('visibility', should_be_visible)
    _.each @_getChildrenModels(), (c)=>
      c.updateByEmblem should_be_visible


  _siblings: (except_itself = false)->
    if parent = @_getParentModel()
      if except_itself
        _.filter parent._getChildrenModels(), (m)=> m.id != @id
      else
        parent._getChildrenModels()#, (m)=> m.id != @id 
    else
      if except_itself
        _.filter @collection.where('parent_id' : 1), (m)=> m.id != @id
      else
        @collection.where('parent_id' : 1)#, (m)=> m.id != @id 

  _getChildrenModels: (options = {})->
    children = _.map @get('children'), (childId) => @collection.findWhere(id: childId)
    if options['full_tree']
      new_children = []
      for c in children
        new_children.concat c._getChildrenModels('full_tree' : true)
      new_children.concat children
    else
      return children

    

  _getVisibleChildrenModels: ->
    _.filter @_getChildrenModels(), (m) -> m.get('visibility')

  
  _getParentModel: ->
    @collection.findWhere id: @get('parent_id')

