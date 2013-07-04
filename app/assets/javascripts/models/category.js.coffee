class Smorodina.Models.Category extends Backbone.Model

  defaults:
    selected: false
    semiSelected: false
    selectedChildren: 0
    rootName: ''
    state: 'deselected'

  initialize: ->
    _.bindAll(@)
  
  # При клике на категорию в дереве
  kickOff: ->
    new_state = if @get( 'state' ) == 'selected' then 'deselected' else 'selected'
    @set 'state', new_state
    @updateParent( parentNode ) if parentNode = @parent()
    @updateChildren( new_state ) if @children()
    @updateSiblings() if @siblings() and new_state = 'selected'
    @collection.trigger 'updateSelectionList'
    @collection.checkWholeSelection()

  # При клике по категории в виде кнопки, скрывам или показываем категории полувыделенными
  updateByEmblem: (is_visible) ->
    @set 'state', ( if is_visible then 'semi-selected' else 'deselected' )
    for child in @children()
      child.updateByEmblem is_visible

  updateParent: (parentNode) ->
    if @all_have_state( parentNode.children(), 'selected' )
      parentNode.set 'state', 'selected'
    else if _.any( parentNode.children(), (category)-> _.include( ['selected', 'bordered'], category.get('state') ) )
      parentNode.set 'state', 'bordered'
    else if @all_have_state( parentNode.children(), 'deselected' )
      parentNode.set 'state', 'deselected'
    for unnecessary_selection in _.filter( @siblings().concat( parentNode.siblings() ), (sibling)-> sibling.get( 'state' ) == 'semi-selected' )
      unnecessary_selection.set 'state', 'deselected'
      unnecessary_selection.updateChildrenLoop 'deselected'
    @updateParent( newParent ) if newParent = parentNode.parent() 
      
  updateChildren: (changedParentState) ->
    @updateChildrenLoop( if changedParentState == 'selected' then 'semi-selected' else 'deselected' )

  updateChildrenLoop: (newState) ->
    for child in @children()
      child.set 'state', newState
      child.updateChildrenLoop newState

  updateSiblings: ->
    siblings_and_self = @siblings_and_self()
    if @all_have_state( siblings_and_self, 'selected' )
      new_state = 'semi-selected'
      elements_to_update = siblings_and_self
    else
      new_state = 'selected'
      elements_to_update =  _.filter( @siblings(), (category) -> category.get( 'state' ) == 'semi-selected' ) 
    for category in elements_to_update
      category.set 'state', new_state

  isActive: ->
   @get('state') != 'deselected'

  siblings: ->
    @get('siblings')

  siblings_and_self: ->
    @siblings().concat @

  parent: ->
    @get('parent')

  children: ->
    @get('children')

  all_have_state: (collection, state) ->
    _.all( collection, (category) -> category.get( 'state' ) == state )
