class Smorodina.Views.EventShow extends Smorodina.Views.Base
  el: '.event_show_page'

  events:
    'click .event_description__right__body__full-link a' : 'show_full_description'
    'click .event_description__left__actions__photo-video a' : 'show_upload_window'
    'click .write_review a' : 'init_add_review'
    'click .cancel_review_creation': 'cancel_add_review'
    'click #save_review': 'create_new_review'

  event_id: 0

  initialize: ->
    _.bindAll @
    geo_object_show()
    @event_id = @options.event_id
    @review_model = new Backbone.Model()
    @reviews_collection = new Backbone.Collection @model, url: "/api/events/#{@event_id}/reviews.json"
    @reviews_view = new Smorodina.Views.ReviewsListView collection: @reviews_collection
    @$('.obj_descr__responces__starter').html @reviews_view.el

    descr_height = @$('.event_description__right__body').innerHeight()
    descr_scroll_height = @$('.event_description__right__body').prop("scrollHeight")

    if descr_height < descr_scroll_height
      @$('.event_description__right').addClass 'slidable'

    $('.obj_descr__text__vote_stats__value__item__value').each (index, record)->
      data = 
        votes_for: parseInt $(record).attr('data-votes-for')
        votes_against: parseInt $(record).attr('data-votes-against')
        current_user_vote: parseInt $(record).attr('data-current-user-vote')
        vote_url: $(record).attr 'data-vote-url'

      model = new Backbone.Model()
      model.set rating: data
      vote_view = new Smorodina.Views.VoteForSimple votable: model, template: 'vote_for_merged'
      $(record).html vote_view.render().el

  show_full_description: (e)->
    e.preventDefault()
    @$('.event_description__right').toggleClass 'opened'

  show_upload_window: (e)->
    e.preventDefault()
    if @is_authorized()
      $('#newimage').modal() 

  init_add_review: (e)->
    e.preventDefault()
    if @is_authorized()
      @reviews_view.init_add_review()

  cancel_add_review: (e)->
    e.preventDefault()
    @reviews_view.cancel_add_review()

  create_new_review: (e)->
    e.preventDefault()

    if @is_authorized()
      data =
        title: @$('#new_review_title').val()
        body: @$('#new_review_body').val()
 
      @reviews_collection.create data,
        wait: true
        success: ->
          @$('.cancel_review_creation').first().click()
