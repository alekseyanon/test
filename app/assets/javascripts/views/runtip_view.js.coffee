class Smorodina.Views.RuntipView extends Smorodina.Views.Base
  className: 'obj_descr__text__descr__runtips__list__record'
  
  template: JST['runtip']

  events:
    'click .obj_descr__text__descr__runtips__list__record__header'  : 'show_runtip'

  initialize: ->
    _.bindAll @
    @render

  render: ->
    @$el.html @template runtip: @model
    vote_model = new Smorodina.Models.Votable @model.get('rating'), url: @model.get('rating').vote_url
    @vote_for_simple = new Smorodina.Views.VoteForSimple model: vote_model, el: @$('.obj_descr__text__descr__runtips__list__record__rate')
    @vote_for_merged = new Smorodina.Views.VoteForSimple model: vote_model, template: 'vote_for_merged', el: @$('.obj_descr__text__descr__runtips__list__record__description__actions__vote')
    @

  show_runtip: (e)->
    tagName = $(e.target).prop 'tagName'
    if tagName != 'A' && tagName != 'BUTTON'
      e.preventDefault()
      if @$el.hasClass 'opened'
        @$el.removeClass 'opened'
        @$el.find('.obj_descr__text__descr__runtips__list__record__description').slideUp()
      else
        @$el.addClass 'opened'
        @$el.find('.obj_descr__text__descr__runtips__list__record__description').slideDown()


