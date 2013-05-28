class Smorodina.Views.ObjectRuntipsView extends Backbone.View
  el: '.obj_descr__text__descr__how_to_reach'
  
  template: JST['runtip_list']

  events:
    'submit .obj_descr__text__descr__how_to_reach__list__add form' : 'create_new_runtip'
    'click .obj_descr__text__descr__how_to_reachi__list__record__header' : 'show_runtip'

  initialize: ->
    _.bindAll(@)
    object_id = $(@el).attr 'data-id'
    @model = new Smorodina.Models.Runtip()
    @collection = new Smorodina.Collections.Runtips(@model, {url: "/api/objects/#{object_id}/runtips.json"})

    @spinner = new Spinner Smorodina.Config.spinner

    $(@el).find('.obj_descr__text__descr__how_to_reach__list').html ''

    @collection.on 'sync', @render
    #@collection.on 'add', @render
    @collection.on 'request', @startRequest

  start: ->
    @collection.fetch()

  render: ->
    @spinner.stop()
    $('.obj_descr__text__descr__how_to_reach__spinner').hide()
    rendered = @template runtips: @collection.toJSON()
    $(@el).find('.obj_descr__text__descr__how_to_reach__list').html rendered
    $(@el).trigger 'runtips_ready'
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
    console.log 'Some errors happened!'

  show_runtip: (e)->
    tagName = $(e.target).prop 'tagName'
    if tagName != 'A' && tagName != 'BUTTON'
      e.preventDefault()
      current = $(e.currentTarget).parent('.obj_descr__text__descr__how_to_reachi__list__record').first()
      if current.hasClass 'opened'
        current.removeClass 'opened'
        current.find('.obj_descr__text__descr__how_to_reachi__list__record__description').slideUp()
      else
        current.addClass 'opened'
        current.find('.obj_descr__text__descr__how_to_reachi__list__record__description').slideDown()


