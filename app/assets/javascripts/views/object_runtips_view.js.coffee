class Smorodina.Views.ObjectRuntipsView extends Backbone.View
  el: '.obj_descr__text__descr__how_to_reach'
  
  template: JST['runtip_list']

  events:
    'submit .obj_descr__text__descr__how_to_reach__list__add form' : 'create_new_runtip'

  initialize: ->
    _.bindAll(@)
    object_id = $(@el).attr 'data-id'
    @model = new Smorodina.Models.Runtip()
    @collection = new Smorodina.Collections.Runtips(@model, {url: "/objects/#{object_id}/runtips.json"})

    @spinner = new Spinner Smorodina.Config.spinner

    $(@el).find('.obj_descr__text__descr__how_to_reach__list').html ''

    @collection.on 'sync', @render
    @collection.on 'add', @render
    @collection.on 'request', @startRequest

  start: ->
    @collection.fetch()

  render: ->
    @spinner.stop()
    $('.obj_descr__text__descr__how_to_reach__spinner').hide()
    rendered = @template runtips: @collection.toJSON()
    $(@el).find('.obj_descr__text__descr__how_to_reach__list').html rendered
    @
    
  startRequest: ->
    $('.obj_descr__text__descr__how_to_reach__spinner').show()
    @spinner.spin($('.obj_descr__text__descr__how_to_reach__spinner').get 0)


  create_new_runtip: (e)->
    e.preventDefault()
    data = 
      body: $(e.currentTarget).find('.pic_comments__add__input input').val()

    @collection.create data,
      wait: true,
      success: ->
        $('.obj_descr__text__descr__how_to_reach__list__add form')[0].reset() 
      error: ->
        @handleCreationError
      

  handleCreationError: ->
    console.logr 'Some errors happened!'
