class Smorodina.Models.Category extends Backbone.Model

  defaults:
    selected: false
    semiSelected: false
    selectedChildren: 0
    rootName: ''

  initialize: ->
    _.bindAll(@)
  
  # При клике на категорию в дереве
  kickOff: ->
    @toggleSelected()
    wasSelected = @get('selected')
    @updateParent()
    
    _.each @children(), (c)->
      c.updateChildren 'semiSelected' : wasSelected, 'selected' : false, 'bordered' : false
  
  # При клике по категории в виде кнопки, скрывам или показываем категории полувыделенными
  updateByEmblem: (val, className)->
    @set 'visibility' : val, 'semiSelected' : val, rootName: className
    @cleanUnwantedStates 'semiSelected'
    _.each @children(), (c)=>
      c.updateByEmblem val

  toggleSelected: ->
    @cleanUnwantedStates 'selected'
    @set 'selected' : !@get('selected')


  updateParent: ->
    parent = @parent()
    
    # Снимаем все полувыделения с родителей, их соседей и потомков 
    for s in (_.filter @siblings(), (s)-> s.get('semiSelected'))
      s.updateChildren 'semiSelected', false 

    if parent
      change_state = false
      # Выделяем родителя, если все дети были выделены
      if _.all(@siblings_and_self(), (s)-> s.get 'selected' )
        change_state = 'selected'
      # Обводим родителя в рамку, если хоть один ребенок выделен
      else if _.any(@siblings_and_self(), (s)-> s.get('selected') or s.get('bordered'))
        change_state = 'bordered'
      else 
        parent.cleanUnwantedStates()
      if change_state
        parent.set change_state, true
        parent.cleanUnwantedStates(change_state)
      parent.updateParent()

  updateChildren: (state, value="")->
    if state instanceof Object
      for k, v of state
        @set k, v
    else
      @set state, value
    _.each @_getVisibleChildrenModels(), (c)=>
      c.updateChildren state, value
        
  # Снимаем все выделения у элемента, кроме...
  cleanUnwantedStates: (exception = "")->
    h = {}
    for state in ['selected', 'semiSelected', 'bordered']
      if state != exception
        h[state] = false
        @set h

  siblings: ->
    collection = if parent = @parent() 
                   parent.children() 
                 else
                   @collection.where('parent_id' : 1)
    _.filter collection, (m)=> m.id != @id

  siblings_and_self: ->
    @siblings().concat @

  parent: ->
    @collection.findWhere(id: @get('parent_id'))

  children: (options = {})->
    _.map @get('children'), (childId) => @collection.findWhere(id: childId)
  
  descendants: ->
    children     = @children()
    new_children = []
    for c in children
      new_children.concat c.descendants()
    new_children.concat children

  descendants_and_self: ->
    @descendants().concat @
  

  _getVisibleChildrenModels: ->
    _.filter @children(), (m) -> m.get('visibility')
