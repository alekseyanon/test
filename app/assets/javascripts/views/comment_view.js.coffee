class Smorodina.Views.CommentView extends Backbone.View
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
    @vote_for_merged = new Smorodina.Views.VoteForSimple votable: @model, template: 'vote_for_merged'
    @sub_comments = new Smorodina.Views.CommentsListView collection: @collection, parent_id: @model.get('id')
    @$el.find('.pic_comments__comment__info__actions__vote').html @vote_for_merged.render().el
    @$el.find('.pic_comments__chid_comments').html @sub_comments.render_collection().el
    @

  respond: (e)->
    e.preventDefault()
    @$el.find('.pic_comments__add').last().slideDown().find('input[type=text]').focus()
                                                                     


