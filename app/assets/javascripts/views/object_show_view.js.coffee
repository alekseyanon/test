class Smorodina.Views.ObjectShow extends Backbone.View
  el: '.obj_show_page'

  events:
    'click .obj_descr__text__descr__how_to_reach a.runtip_switcher' : 'init_runtips'

  object_id: 0

  initialize: ->
    _.bindAll @
    @object_id = @options.object_id

  init_runtips: (e)-> 
    e.preventDefault()
    if !@runtips_view
      @runtip_model = new Smorodina.Models.Runtip()
      @runtips_collection = new Smorodina.Collections.Runtips(@model, {url: "/api/objects/#{@object_id}/runtips.json"})
      @runtips_view = new Smorodina.Views.ObjectRuntipsView collection: @runtips_collection
