#= require models/category

class Smorodina.Collections.Categories extends Backbone.Collection
  model: Smorodina.Models.Category
  url: '/api/categories/index'

  initialize: () ->
    @on 'reset', @establishRelatives
  
  updateEmblemCategory: (name, is_selected) ->
    @findWhere(name: name).updateByEmblem(is_selected)

  activeElements: ->
    @filter (category) ->
      category.get('state') == 'selected'

  fromListToTree: (categories_name_list) ->
    selected = @filter (category) -> _.include( categories_name_list, category.get('name') )
    ordered_categories =  _.sortBy( selected, (category) -> category.get('depth') ).reverse()
    @resetAll()
    for c in ordered_categories
      c.kickOff()

  # Ugly workaround
  resetAll: ->
    for category in @models
      category.set 'state' ,'deselected'
  
  updateEmblemCategory: (name, is_selected)->
    _.each @where(name: name), (category) ->
      category.updateByEmblem(is_selected)

  comparator: (record)->
    record.get('order')

  checkWholeSelection: ->
    roots = @filter (category) -> category.get('parent_id') == 1 and category.get('name') != 'infrastructure'
    for category in roots
      @trigger 'switchLegend', category.get('name'), category.isActive()

  establishRelatives: ->
    for category in @models
      @establishParent   category
      @establishChildren category
      @establishSiblings category

  establishParent: (category) ->
    category.set 'parent', @findWhere( id : category.get('parent_id') )

  establishChildren: (category) ->
    children = []
    for child in category.get('children')
      children.push child if child = @findWhere( id : child )
    category.set 'children', children

  establishSiblings: (category) ->
    collection = ( if parent = category.get('parent') then parent.children() else @where( 'parent_id' : 1 ) )
    siblings   = _.filter collection, (m) -> m.id != category.id
    category.set 'siblings', siblings

  markLeafs: ->
    leafs = @filter (category) -> category.get( 'children' ).length == 0
    for leaf in leafs
      leaf.trigger 'actsAsLeaf'
