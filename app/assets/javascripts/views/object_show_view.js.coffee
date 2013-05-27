class Smorodina.Views.ObjectShow extends Backbone.View
  el: '.obj_show_page'

  events:
    'click .obj_descr__text__descr__how_to_reach a.runtip_switcher' : 'init_runtips'
    'runtips_ready .obj_descr__text__descr__how_to_reach' : 'runtips_ready'

  initialize: ->
    @vote_for_simple_view = new Smorodina.Views.VoteForSimple


  init_runtips: (e)-> 
    e.preventDefault()
    if !@runtips_view
      @runtips_view = new Smorodina.Views.ObjectRuntipsView
      @runtips_view.start()

  runtips_ready: (e)->
    @vote_for_simple_view = new Smorodina.Views.VoteForSimple


