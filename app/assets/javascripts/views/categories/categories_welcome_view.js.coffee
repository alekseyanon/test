#= require collections/categories
#= require views/base_view

class Smorodina.Views.CategoriesWelcome extends Smorodina.Views.Base

  el: '#searchFilter'

  events:
    'click .search-filter__categories button' : 'toggleEmblemCategory'

  toggleEmblemCategory: (emblem)->
    name = $(emblem.currentTarget).attr('data-facet')
    is_selected = $(emblem.currentTarget).hasClass('selected')
    @collection.updateEmblemCategory name, is_selected
    @collection.checkWholeSelection()
      
  initialize: ->
    super()
    window.tt = @collection
    @shown_root_categories = $('.search-filter__categories button').map -> $(@).attr('data-facet')
    @$categories = $('.search-filter__second-level')[0]
    @collection.on 'reset', @render
    @collection.on 'switchLegend', @switchLegend
    @collection.fetch(reset: true)

  render: ->
    @orderFullList()
    list = @collection.filter (record)->
      return _.include(['sightseeing', 'activities', 'food', 'lodging'], record.get('name')) && record.get('depth') == 1
    
    _.each list, (record)->
      @$('.search-filter__second-level').append "<li class='level_1 #{record.get('name')}'><span class='block-icon'></span><ul class='level_1_container'></ul></li>"

    _.each @collection.where(depth: 2), @addOne
    @collection.markLeafs()

  addOne: (model) ->
    category = new Smorodina.Views.Category(model:model)
    root_cat = @collection.where(id: model.get('parent_id'))
    @$(".#{root_cat[0].get('name')} ul").first().append category.render().el

  switchLegend: (facet, selected) -> 
    $(".search-filter__category_#{facet}").toggleClass 'selected', selected
    $(".level_1.#{facet} .block-icon").toggleClass 'active', selected

  orderFullList: ->
    #Custom reordering
    for name, i in ['lodging' 
                     'sightseeing' 
                     'activities' 
                     'food' 
                     'active_recreation' 
                     'entertainment']
      @collection.findWhere(name: name).set('order': i)
    @collection.sort()

  orderLightList: ->

