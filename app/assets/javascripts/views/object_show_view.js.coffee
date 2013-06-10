class Smorodina.Views.ObjectShow extends Smorodina.Views.Base
  el: '.obj_show_page'

  events:
    'click .obj_descr__text__descr__runtips a.runtip_switcher' : 'init_runtips'
    'click .obj_descr__text__descr__body__full_link a' : 'show_full_description'

  object_id: 0

  initialize: ->
    _.bindAll @
    @object_id = @options.object_id
    @review_model = new Backbone.Model()
    @reviews_collection = new Backbone.Collection @model, url: "/api/objects/#{@object_id}/reviews.json"
    @reviews_view = new Smorodina.Views.ReviewsListView collection: @reviews_collection
    @$('.obj_descr__responces__starter').html @reviews_view.el

    descr_height = @$('.obj_descr__text__descr__body').innerHeight()
    descr_scroll_height = @$('.obj_descr__text__descr__body').prop("scrollHeight")

    if descr_height < descr_scroll_height
      @$('.obj_descr__text__descr').addClass 'slidable'

    $('.obj_descr__text__vote_stats__value__item__value').each (index, record)->
      data = 
        votes_for: parseInt $(record).attr('data-votes_for')
        votes_against: parseInt $(record).attr('data-votes_against')
        current_user_vote: parseInt $(record).attr('data-current_user_vote')
        vote_url: $(record).attr 'data-vote_url'

      model = new Backbone.Model()
      model.set rating: data
      vote_view = new Smorodina.Views.VoteForSimple votable: model, template: 'vote_for_merged'
      $(record).html vote_view.render().el

  init_runtips: (e)-> 
    e.preventDefault()
    if !@runtips_view
      @runtip_model = new Smorodina.Models.Runtip()
      @runtips_collection = new Smorodina.Collections.Runtips @model, url: "/api/objects/#{@object_id}/runtips.json"
      @runtips_view = new Smorodina.Views.ObjectRuntipsView collection: @runtips_collection

  show_full_description: (e)->
    e.preventDefault()
    @$('.obj_descr__text__descr').toggleClass 'opened'
