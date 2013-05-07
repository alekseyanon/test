#= require collections/categories
#= require views/base_view
#= require ./category_view

class Smorodina.Views.Categories extends Smorodina.Views.Base
  el: '.search-filter__second-level'
  initialize: ->
    super()
    @collection.on 'reset', @render
    @collection.fetch(reset: true)

  render: ->
    @fragment = document.createDocumentFragment()
    _.each @collection.where(depth: 1), @addOne
    @$el.empty().append(@fragment)

  addOne: (model) ->
    category = new Smorodina.Views.Category(model:model)
    @fragment.appendChild category.render().el
