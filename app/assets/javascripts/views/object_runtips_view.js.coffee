class Smorodina.Views.ObjectRuntipsView extends Backbone.View
  el: '.obj_descr__text__descr__how_to_reach__list__container'
  
  template: JST['runtip_list']

  events:
    'submit .obj_descr__text__descr__how_to_reach__list__add form': 'create_new_runtip'

  list_container: null

  initialize: ->
    _.bindAll @
    @collection.on 'sync', @render
    @collection.fetch()
    @list_container = @$el.find('.obj_descr__text__descr__how_to_reach__list')

  render: ->
    _.each @collection.models, @render_runtip
    @

  render_runtip: (runtip)->
    view = new Smorodina.Views.RuntipView model: runtip
    @list_container.append view.render().el

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


