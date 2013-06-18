#= require collections/categories
#= require views/base_view

class Smorodina.Views.CategoriesWelcome extends Smorodina.Views.Base

  el: '#searchFilter'

  events:
    'click .search-filter__categories button' : 'toggleEmblemCategory'
    'click .search-filter__switcher' : 'toggleAllCategories'

  toggleEmblemCategory: (emblem)->
    name = $(emblem.currentTarget).attr('data-facet')
    is_selected = $(emblem.currentTarget).hasClass('selected')
    @collection.updateEmblemCategory name, is_selected

  toggleAllCategories:(e) ->
    @shouldSelectAll = !@shouldSelectAll
    self = @
    $('.search-filter__categories button').each ->
      $(@).toggleClass 'selected', self.shouldSelectAll
      self.collection.updateEmblemCategory $(@).attr('data-facet'), self.shouldSelectAll
  

  initialize: ->
    super()
    window.tt = @collection
    @shown_root_categories = $('.search-filter__categories button').map -> $(@).attr('data-facet')

    @$categories = $('.search-filter__second-level')[0]
    @collection.on 'reset', @render
    @collection.fetch(reset: true)

  render: ->
    _.each @collection.where(depth: 1), @addOne

  addOne: (model) ->
    category = new Smorodina.Views.Category(model:model)
    @$categories.appendChild category.render().el
