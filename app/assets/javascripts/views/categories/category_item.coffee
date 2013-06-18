class Smorodina.Views.Category extends Backbone.View
  tagName: 'li'
  template: JST['category'],
  events:
    'click': 'toggle'

  initialize: ->
    _.bindAll(@)
    @model.on 'change:visibility', @toggleVisibility
    @model.on 'change:selected', @toggleSelected
    @model.on 'change:semiSelected', @toggleSemiSelected
    @model.on 'change:bordered', @toggleBordered

  render: ( visible = false )->
    @are_categories_visible_by_default = visible
    @$el.append @template @model.toJSON()
    @model.set('visibility', @are_categories_visible_by_default)
    subLevel = @model.collection.where(depth: @model.get('depth') + 1, parent_id: @model.get('id'))
    @renderSubLevel(subLevel) if subLevel.length
    @

  renderSubLevel: (subCategories) ->
    @$subList = $ '<ul>'
    _.each subCategories, @addOne
    @$el.append @$subList

  addOne: (subCategory) ->
    view = new Smorodina.Views.Category(model: subCategory)
    @$subList.append view.render(@are_categories_visible_by_default).el

  toggle: (e) ->
    @model.kickOff()
    e.stopPropagation()

  toggleVisibility: (model, val)->
    @$el.toggle val 
    
  toggleBordered: ->
    @$el.toggleClass 'bordered', @model.get('bordered')

  toggleSemiSelected: ->
    @$el.toggleClass 'semi-selected', @model.get('semiSelected')


  toggleSelected: ->
    @$el.toggleClass 'selected', @model.get('selected')
