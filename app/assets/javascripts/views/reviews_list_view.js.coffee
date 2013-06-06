class Smorodina.Views.ReviewsListView extends Backbone.View
  className: 'obj_descr__responces'
  
  template: JST['review_list']

  index: 0

  events: 
    'click .obj_descr__responces_count a' : 'show_all'

  initialize: ->
    _.bindAll @
    @collection.on 'sync', @render
    @collection.fetch()

  render: ->
    @$el.html @template count: @collection.length
    _.each @collection.models, @render_one
    @

  render_one: (review)->
    view = new Smorodina.Views.ReviewView model: review
    rendered = view.render().el
    @$el.find('.obj_descr__responces__container').append rendered

    height = view.$('.obj_descr__responces__responce__text__data').innerHeight()
    scrollHeight = view.$('.obj_descr__responces__responce__text__data').prop("scrollHeight")

    if height < scrollHeight
      view.$el.addClass 'slidable'

    if ++@index > 3
      view.$el.addClass 'hidable_review'



  create_new_runtip: (e)->
    e.preventDefault()
    data =
      body: @$el.find('.pic_comments__add__input input').val()

    @collection.create data,
      wait: true,
      success: ->
        $('.obj_descr__text__descr__how_to_reach__list__add form')[0].reset()
      error: ->
        @handleCreationError
                                                                     

  handleCreationError: ->
    console.log 'Some errors happened!'

  show_all: (e)->
    e.preventDefault()
    @$el.toggleClass 'show_all'


