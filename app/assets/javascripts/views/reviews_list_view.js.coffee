class Smorodina.Views.ReviewsListView extends Backbone.View
  className: 'obj_descr__responces'
  
  template: JST['review_list']

  initialize: ->
    _.bindAll @
    @collection.on 'sync', @render
    @collection.fetch()

  render: ->
    @$el.html @template count: @collection.count
    _.each @collection.models, @render_one
    @

  render_one: (review)->
    view = new Smorodina.Views.ReviewView model: review
    @$el.find('.obj_descr__responces__container').append view.render().el


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


