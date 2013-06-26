class Smorodina.Views.Category extends Backbone.View
  tagName: 'li'
  template: JST['category'],
  events:
    'click': 'toggle'

  initialize: ->
    _.bindAll(@)
    #@model.on 'change:visibility', @toggleVisibility
    @model.on 'change:selected', @toggleSelected
    @model.on 'change:semiSelected', @toggleSemiSelected
    @model.on 'change:bordered', @toggleBordered
    @model.on 'change:rootName', @setRootClass

  render: ->
    @$el.append @template @model.toJSON()
    #@model.set('visibility', false)
    @$el.addClass "level_#{@model.get('depth')} #{@model.get('name')}"

    subLevel = @model.collection.where(depth: @model.get('depth') + 1, parent_id: @model.get('id'))
    if subLevel.length
      @$el.addClass "hasChilds"
      @renderSubLevel(subLevel)
    @

  renderSubLevel: (subCategories) ->
    @$subList = $ "<ul class='level_#{@model.get('depth')}_container'>"
    _.each subCategories, @addOne
    @$el.append @$subList

  addOne: (subCategory) ->
    view = new Smorodina.Views.Category(model: subCategory)
    @$subList.append view.render().el

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

  setRootClass: ->
    @$el.addClass @model.get('rootName')

