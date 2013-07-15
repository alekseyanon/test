class Smorodina.Views.ReviewView extends Smorodina.Views.Base
  className: 'obj_descr__review__record'
  
  template: JST['review']

  comments_list: false
  
  real: true

  events:
    'click .pic_comments__count__text'  : 'show_comments'
    'click .obj_descr__responces__responce__text__actions__respond a' : 'respond'
    'click .obj_descr__responces__responce__text__show_full a' : 'show_full'
    'slided .pic_comments__container' : 'container_ready'

  initialize: ->
    _.bindAll @

    if @options.real != undefined
      @real = @options.real

    if @real
      @comments_collection = new Smorodina.Collections.Comments(
        [], 
        url: "/api/reviews/#{@model.get('id')}/comments"
      )

      @comments_list = new Smorodina.Views.CommentsListView 
        collection: @comments_collection, 
        parent_id: null, 
        hash: "review_#{@model.get('id')}_add_comment_form"

      @comments_list.on 'ready', @comments_ready

  render: ->
    @$el.html @template review: @model, real: @real
    @$el.find('.pic_comments__container').css display: 'none'
    if @real
      vote_model = new Smorodina.Models.Votable(
        @model.get('rating'), 
        url: @model.get('rating').vote_url
      )

      @vote_for_merged = new Smorodina.Views.VoteForSimple
        model: vote_model, 
        template: 'vote_for_merged', 
        el: @$el.find('.obj_descr__responces__responce__text__actions__vote')

      @spam_to = new Smorodina.Views.SpamToView 
        complaint: @model.get('complaint'), 
        el: @$el.find('.obj_descr__responces__responce__text__actions__spam')

      @$el.find('.pic_comments').append @comments_list.hide().render().el
    else
      @$el.addClass 'slidable show_full'
    @

  show_comments: ()->
    @current_hash = ''
    @$el.find('.pic_comments__container').first().slideToggle 'fast', ()->
      $(this).trigger 'slided'
      
    @$el.toggleClass 'opened'
    
  container_ready: ()->
    if !@comments_list.collection.length
      if @$el.hasClass('opened')
        @comments_list.build()
    else
      if @$el.hasClass('opened') && @current_hash
        @comments_ready()

  comments_ready: (event)->
    if @current_hash
      window.location.hash = @current_hash
      @$el.find('.pic_comments__container').first().find('input[type=text]').last().focus()

  show_full: (e)->
    e.preventDefault()
    @$el.toggleClass 'show_full'

  respond: (e)->
    e.preventDefault()
    @show_comments()
    @current_hash = e.currentTarget.hash

