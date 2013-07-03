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

  toggleFilter: ->
    @openFilter()
    @$switcher.add(@$secondLevel).toggleClass('selected')
    @$secondLevel.toggleClass 'full-list'
     

  selectCategory: (e) ->
    @openFilter()
    $(e.currentTarget).toggleClass('selected')

  openFilter: ->
    if !@$('.second-level__container').hasClass('oppened')
      @$('.second-level__container').slideDown();
      @$('.second-level__container').addClass 'oppened'
     

