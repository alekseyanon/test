class Smorodina.Views.ReviewView extends Backbone.View
  className: 'obj_descr__review__record'
  
  template: JST['review']

  comments_list: false

  events:
    'click .pic_comments__count__text'  : 'show_comments'
    'click .obj_descr__responces__responce__text__actions__respond a' : 'respond'

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
    @tag_name = $(e.target).prop 'tagName'
    @$el.find('.pic_comments__container').first().slideToggle()

    if !@$el.hasClass 'opened'
      if !@comments_list
          @comments_collection = new Smorodina.Collections.Comments [], url: "/api/reviews/#{@model.get('id')}/comments"
          @comments_list = new Smorodina.Views.CommentsListView collection: @comments_collection, parent_id: null
          @$el.find('.pic_comments').append @comments_list.render().el

    
    @$el.toggleClass 'opened'
    e.preventDefault()


  respond: (e)->
    @show_comments(e)
    @$el.find('.pic_comments__container').first().find('input[type=text]').last().focus()

