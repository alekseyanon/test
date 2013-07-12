class Smorodina.Views.CommentView extends Smorodina.Views.Base
  className: 'pic_comments__comment'
  
  template: JST['comment']

  events:
    'click .pic_comments__comment__info__actions__respond a' : 'respond'

  initialize: ->
    @collection = @options.collection
    _.bindAll @
    @render


  render: ->
    @$el.html @template comment: @model
    @sub_comments = new Smorodina.Views.CommentsListView collection: @collection, parent_id: @model.get('id'), hash: "comment_#{@model.get('id')}_add_comment_form"
    vote_model = new Backbone.Model @model.get('rating'), url: @model.get('rating').vote_url
    @vote_for_merged = new Smorodina.Views.VoteForSimple model: vote_model, template: 'vote_for_merged', el: @$el.find('.pic_comments__comment__info__actions__vote')
    @spam_to = new Smorodina.Views.SpamToView complaint: @model.get('complaint'), el: @$el.find('.pic_comments__comment__info__actions__spam')

    @$el.find('.pic_comments__chid_comments').html @sub_comments.render_collection().el
    @

  respond: (e)->
    e.preventDefault()
    @$el.find('.pic_comments__add').last().slideDown().find('input[type=text]').focus()
                                                                     


