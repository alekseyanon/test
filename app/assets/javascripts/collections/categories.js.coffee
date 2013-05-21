#= require models/category

class Smorodina.Collections.Categories extends Backbone.Collection
  model: Smorodina.Models.Category
  url: '/api/categories/index'
  
  updateEmblemCategory: (name, is_selected)->
  	_.each @where(name: name), (category) ->
	    category.updateByEmblem(is_selected)