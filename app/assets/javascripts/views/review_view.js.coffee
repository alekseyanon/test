class Smorodina.Views.ReviewView extends Backbone.View
  className: 'obj_descr__review__record'
  
  template: JST['review']

  comments_list: false

  events:
    'click .pic_comments__count__text'  : 'show_comments'

  initialize: ->
    _.bindAll @
    @render


  render: ->
    @$el.html @template review: @model
    @$el.find('.pic_comments__container').css display: 'none'
    @vote_for_merged = new Smorodina.Views.VoteForSimple votable: @model, template: 'vote_for_merged'
    @$el.find('.obj_descr__responces__responce__text__actions__vote').html @vote_for_merged.render().el
    @

  show_comments: (e)->
    e.preventDefault()
    if @$el.hasClass 'opened'
      @$el.removeClass 'opened'
      @$el.find('.pic_comments__container').slideUp()
    else
      @$el.addClass 'opened'
      @$el.find('.pic_comments__container').slideDown()
      if !@comments_list
        @comments_collection = new Smorodina.Collections.Comments [], url: "/api/reviews/#{@model.get('id')}/comments"
        @comments_list = new Smorodina.Views.CommentsListView collection: @comments_collection, parent_id: null
        @$el.find('.pic_comments__list').html @comments_list.el




