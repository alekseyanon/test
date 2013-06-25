#= require models/category

class Smorodina.Collections.Categories extends Backbone.Collection
  model: Smorodina.Models.Category
  url: '/api/categories/index'
  
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
