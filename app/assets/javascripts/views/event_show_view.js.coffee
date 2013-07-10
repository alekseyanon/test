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

    @init_like_btn()
    @init_go_btn()

  init_go_btn: ->
    data = 
      rating: parseInt @$('.event_description__right__actions__go').attr('data-rating')
      current_user_vote: parseInt @$('.event_description__right__actions__go').attr('data-current-user-vote')

    model = new Backbone.Model data, url: @$('.event_description__right__actions__go').attr 'data-vote-url'
    go_btn = new Smorodina.Views.GoBtn votable: model
    @$('.event_description__right__actions__go').html go_btn.render().el

  init_like_btn: ->
    data =
      current_user_vote: parseInt @$('.event_description__right__actions__like').attr('data-current-user-vote')
      state: @$('.event_description__right__actions__like').attr 'data-state'


    model = new Backbone.Model data, url: @$('.event_description__right__actions__like').attr 'data-vote-url'
 
    console.log model.attributes
    like_btn = new Smorodina.Views.LikeBtn votable: model
    @$('.event_description__right__actions__like').html like_btn.render().el
    

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
