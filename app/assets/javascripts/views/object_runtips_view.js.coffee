class Smorodina.Views.ObjectRuntipsView extends Backbone.View
  el: '.obj_descr__text__descr__how_to_reach'
  
  template: JST['runtip_list']

  events:
    'submit .obj_descr__text__descr__how_to_reach__list__add form' : 'create_new_runtip'

  initialize: ->
    _.bindAll(@)
    object_id = $(@el).attr('data-id')
    @model = new Smorodina.Models.Runtip()
    @collection = new Smorodina.Collections.Runtips(@model, {url: "/objects/#{object_id}/runtips.json"})

    $(@el).find('.obj_descr__text__descr__how_to_reach__list').html ''
    $(@el).find('.obj_descr__text__descr__how_to_reach__list__container').slideDown()

    @collection.on 'sync', @render
    @collection.on 'request', @startRequest

    @collection.fetch()

  render: ->
    rendered = @template runtips: @collection.toJSON()
    $(@el).find('.obj_descr__text__descr__how_to_reach__list').html rendered
    @
    
  startRequest: ->
    console.log 'request started'

  create_new_runtip: (e)->
    e.preventDefault()
    data = 
      body: $(e.currentTarget).find('.pic_comments__add__input input').val()

    @collection.create data,
      wait: true,
      success: ->
        @render
      error: ->
        @handleCreationError
      

  handleCreationError: ->
    console.logr 'Some errors happened!'
