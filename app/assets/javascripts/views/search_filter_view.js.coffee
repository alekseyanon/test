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

  toggleFilter: ->
    @$switcher.add(@$secondLevel).toggleClass('selected')
    @$secondLevel.toggleClass 'full-list'

  selectCategory: (e) ->
    $(e.currentTarget).toggleClass('selected')
