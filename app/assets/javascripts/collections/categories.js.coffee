#= require models/category

class Smorodina.Collections.Categories extends Backbone.Collection
  model: Smorodina.Models.Category
  url: '/api/categories/index'
  
  updateEmblemCategory: (name, is_selected)->
    @findWhere(name: name).updateByEmblem(is_selected)
