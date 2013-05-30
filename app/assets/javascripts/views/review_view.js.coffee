class Smorodina.Views.ReviewView extends Backbone.View
  className: 'obj_descr__review__record'
  
  template: JST['review']

  events:
    'click .pic_comments__count__text'  : 'show_comments'

  initialize: ->
    _.bindAll @
    @render


  render: ->
    @$el.html @template review: @model
    #@vote_for_simple = new Smorodina.Views.VoteForSimple votable: @model
    #@vote_for_merged = new Smorodina.Views.VoteForSimple votable: @model, template: 'vote_for_merged'
    #@$el.find('.obj_descr__text__descr__how_to_reach__list__record__rate').html @vote_for_simple.render().el
    #@$el.find('.obj_descr__text__descr__how_to_reach__list__record__description__actions__vote').html @vote_for_merged.render().el
    @

  show_comments: (e)->
    console.log 'showing comments'
    e.preventDefault()
    if @$el.hasClass 'opened'
      @$el.removeClass 'opened'
      @$el.find('.pic_comments__container').slideUp()
    else
      @$el.addClass 'opened'
      @$el.find('.pic_comments__container').slideDown()


