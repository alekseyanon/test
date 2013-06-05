class Smorodina.Views.RuntipView extends Backbone.View
  className: 'obj_descr__text__descr__how_to_reach__list__record'
  
  template: JST['runtip']

  events:
    'click .obj_descr__text__descr__how_to_reach__list__record__header'  : 'show_runtip'

  initialize: ->
    _.bindAll @
    @render

  render: ->
    @$el.html @template runtip: @model
    @vote_for_simple = new Smorodina.Views.VoteForSimple votable: @model
    @vote_for_merged = new Smorodina.Views.VoteForSimple votable: @model, template: 'vote_for_merged'
    @$el.find('.obj_descr__text__descr__how_to_reach__list__record__rate').html @vote_for_simple.render().el
    @$el.find('.obj_descr__text__descr__how_to_reach__list__record__description__actions__vote').html @vote_for_merged.render().el
    @

  show_runtip: (e)->
    tagName = $(e.target).prop 'tagName'
    if tagName != 'A' && tagName != 'BUTTON'
      e.preventDefault()
      if @$el.hasClass 'opened'
        @$el.removeClass 'opened'
        @$el.find('.obj_descr__text__descr__how_to_reach__list__record__description').slideUp()
      else
        @$el.addClass 'opened'
        @$el.find('.obj_descr__text__descr__how_to_reach__list__record__description').slideDown()


