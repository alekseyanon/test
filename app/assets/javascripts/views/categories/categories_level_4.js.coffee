#= require collections/categories
#= require views/base_view

class Smorodina.Views.CategoriesLevel4 extends Smorodina.Views.Base
  class: '.search-filter__level-4'
  initialize: ->
    super()

  render: ->
    @fragment = document.createDocumentFragment()
    _.each @collection.where(depth: 4), @addOne
    @$el.empty().append(@fragment)
    @

  addOne: (model) ->
    category = new Smorodina.Views.Category(model:model)
    @fragment.appendChild category.render().el
