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
    @$('.second-level__container').hide()
    @$secondLevelContainer = @$secondLevel.parent()
    
  toggleFilter: ->
    @openFilter()
    @$switcher.add(@$secondLevel).toggleClass('selected')
    @$secondLevel.toggleClass 'full-list'
     
    if @$secondLevel.hasClass 'full-list'
      @recalculateFoodMargin()
    else
      @resetHeight()
      
  recalculateFoodMargin: ->
    @params ?= 
      entertainment_height: eh = $('.level_2.entertainment').height()
      activities_height:    ah = $('.level_2.active_recreation').height()
      foodMargin:           ah - eh
      $food:                $('.level_1.food')
    parent_category_offset = 13
    @params['$food'].css 'margin-top', "-#{@params['foodMargin'] - parent_category_offset }px"

  resetHeight: ->
    @params['$food'].attr 'style', ''

  selectCategory: (e) ->
    @openFilter()
    $(e.currentTarget).toggleClass('selected')

  openFilter: ->
    unless @$('.second-level__container').hasClass('oppened')
      @$('.second-level__container').slideDown();
      @$('.second-level__container').addClass 'oppened'
     

