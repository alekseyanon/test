#= require ./base_view

class Smorodina.Views.SearchFilter extends Smorodina.Views.Base
  el: '#searchFilter'

  events:
    'click .search-filter__switcher': 'toggleFilter'
    'click .search-filter__category': 'selectCategory'

  initialize: ->
    super()
    @$categories = @$ '.search-filter__category'
    @$switcher = @$ '.search-filter__switcher'
    @$secondLevel = @$ '.search-filter__second-level'
    @$secondLevelContainer = @$secondLevel.parent()
    # Показываем категории, когда кликнули впервые
    @$secondLevelContainer.hide()
    @bindFirstTimeSelection()

  bindFirstTimeSelection: ->
    for elem in [ @$categories, @$switcher ]
      elem.on 'click.firstTime', =>
        @$secondLevelContainer.show()
        elem.off 'click.firstTime'
    
  toggleFilter: ->
    @$switcher.add(@$secondLevel).toggleClass('selected')
    @$secondLevel.toggleClass 'full-list'
    if @$secondLevel.hasClass 'full-list'
      @recalculateFoodMargin()
    else
      @resetHeight()
      
  recalculateFoodMargin: ->
    if !@params
      @params = {}
      @params['entertainment_height'] = $('.level_2.entertainment').height()
      @params['activities_height']    = $('.level_2.active_recreation').height()
      @params['foodMargin']           = @params['activities_height'] - @params['entertainment_height']
      @params['$food']                = $('.level_1.food')
    parent_category_offset = 13
    @params['$food'].css 'margin-top', "-#{@params['foodMargin'] - parent_category_offset }px"

  resetHeight: ->
    @params['$food'].attr 'style', ''

  selectCategory: (e) ->
    $(e.currentTarget).toggleClass('selected')
