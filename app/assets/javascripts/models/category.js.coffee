class Smorodina.Models.Category extends Backbone.Model

  defaults:
    state: 'deselected'

  initialize: ->
    _.bindAll(@)
  
  # При клике на категорию в дереве
  kickOff: ->
    if @get( 'state' ) == 'selected'
      new_state = 'deselected'
    else
      new_state = 'selected'
    @set( 'state', new_state )
    @updateParent( parentNode ) if parentNode = @parent()
    @updateChildren( new_state ) if @children()
    @updateSiblings() if @siblings() and new_state = 'selected'
    @collection.trigger 'updateSelectionList'
    
  # При клике по категории в виде кнопки, скрывам или показываем категории полувыделенными
  updateByEmblem: (is_visible)->
    @set 'visibility' : is_visible
    if is_visible
      @set 'state', 'semi-selected'
    else
      @set 'state', 'selected'
    for child in  @children()
      child.updateByEmblem is_visible

  updateParent: (parentNode)->
    if _.all( parentNode.children(), (category)-> category.get('state') == 'selected' )
      parentNode.set 'state', 'selected'
    else if _.any( parentNode.children(), (category)-> _.include( ['selected', 'bordered'], category.get('state') ) )
      parentNode.set 'state', 'bordered'
    else if _.all( parentNode.children(), (category)-> category.get('state') == 'deselected' )
      parentNode.set 'state', 'deselected'
    for unnecessary_selection in _.filter( @siblings().concat( parentNode.siblings() ), (sibling)-> sibling.get( 'state' ) == 'semi-selected' )
      unnecessary_selection.set 'state', 'deselected'
      unnecessary_selection.updateChildrenLoop 'deselected'
    @updateParent( newParent ) if newParent = parentNode.parent() 
      
  updateChildren: (changedState)->
    if changedState == 'selected'
      @updateChildrenLoop 'semi-selected'
    else
      @updateChildrenLoop 'deselected'

  updateChildrenLoop: (newState)->
    _.each @children(), (c) =>
      c.set 'state', newState
      c.updateChildrenLoop newState

  updateSiblings: ->
    siblings_and_self = @siblings_and_self()
    if _.all( siblings_and_self, (category) -> category.get( 'state' ) == 'selected' )
      new_state = 'semi-selected'
      elements_to_update = @siblings_and_self()
    else
      new_state = 'selected'
      elements_to_update =  _.filter( @siblings(), (category) -> category.get( 'state' ) == 'semi-selected' ) 
    for category in elements_to_update
      category.set 'state', new_state

  siblings: ->
    collection = if parent = @parent() 
                   parent.children() 
                 else
                   @collection.where( 'parent_id' : 1 )
    _.filter collection, (m)=> m.id != @id

  siblings_and_self: ->
    @siblings().concat @

  parent: ->
    @collection.findWhere( id: @get( 'parent_id' ) )

  children: ->
    children_ids = @get('children')
    @collection.filter (category)-> _.include( children_ids, category.id )
