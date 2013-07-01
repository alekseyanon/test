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
    #@collection.on 'allSelected', @switchTumbler
    @collection.on 'switchLegend', @switchLegend
    @collection.fetch(reset: true)

  render: ->
    @orderFullList()
    list = @collection.filter (record)->
      names = ['sightseeing', 'activities', 'food', 'lodging']
      return _.indexOf(names, record.get('name')) != -1 && record.get('depth') == 1
    
    _.each list, (record)->
      @$('.search-filter__second-level').append "<li class='level_1 #{record.get('name')}'><span class='block-icon'></span><ul class='level_1_container'></ul></li>"

    _.each @collection.where(depth: 2), @addOne
    @collection.markLeafs()

  addOne: (model) ->
    category = new Smorodina.Views.Category(model:model)
    root_cat = @collection.where(id: model.get('parent_id'))
    @$(".#{root_cat[0].get('name')} ul").first().append category.render().el

  #switchTumbler: (state) ->
  #  $('.search-filter__switcher').toggleClass 'selected', state

  switchLegend: (facet, selected) -> 
    # если selected, то мы можем раскрасить иконку
    $(".search-filter__category_#{facet}").toggleClass 'selected', selected

  orderFullList: ->
    #Custom reordering
    @collection.findWhere(name: 'sightseeing').set('order': 2)
    @collection.findWhere(name: 'activities').set('order': 3)
    @collection.findWhere(name: 'food').set('order': 4)
    @collection.findWhere(name: 'lodging').set('order': 1)
    @collection.findWhere(name: 'active_recreation').set('order': 5)
    @collection.findWhere(name: 'entertainment').set('order': 6)
    @collection.sort()

  orderLightList: ->

