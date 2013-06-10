class Smorodina.Views.ObjectRuntipsView extends Smorodina.Views.Base
  el: '.obj_descr__text__descr__runtips__list__container'
  
  template: JST['runtip_list']

  events:
    'submit .obj_descr__text__descr__runtips__list__add form': 'create_new_runtip'

  list_container: null

  initialize: ->
    _.bindAll @
    @collection.on 'add', @render_runtip
    @collection.fetch()
    @list_container = @$('.obj_descr__text__descr__runtips__list')

  render_runtip: (runtip)->
    view = new Smorodina.Views.RuntipView model: runtip
    @list_container.append view.render().el

  create_new_runtip: (e)->
    e.preventDefault()

    if !@is_authorized()
      @show_login()
      return

    data =
      body: @$el.find('.pic_comments__add__input input').val()

    @collection.create data,
      wait: true,
      success: ->
        $('.obj_descr__text__descr__runtips__list__add form')[0].reset()
      error: ->
        @handleCreationError()
                                                                     

  handleCreationError: ->
    console.log 'Some errors happened!'
