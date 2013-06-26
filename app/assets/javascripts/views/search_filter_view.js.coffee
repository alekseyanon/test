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

    #if @$secondLevel.hasClass 'selected'
      #$('.search-filter__second-level .active_recreation .level_2_container').masonry
      #                        itemSelector: '.level_3.hasChilds'
      #                        gutterWidth: 0
      #                        stamp: 'span.filter-category__text'

      #$('.search-filter__second-level .level_1_container').masonry
      #                        itemSelector: '.level_2.hasChilds'
      #                        gutterWidth: 0


      #$('.search-filter__second-level').masonry
      #                        itemSelector: '.level_1'
      #                        gutterWidth: 0
                              
      
  selectCategory: (e) ->
    $(e.currentTarget).toggleClass('selected')
