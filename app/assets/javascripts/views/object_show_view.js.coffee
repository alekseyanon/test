class Smorodina.Views.ObjectShow extends Backbone.View
  el: '.obj_show_page'

  events:
    'click .obj_descr__text__descr__how_to_reach a' : 'init_runtips'

  init_runtips: (e)-> 
    e.preventDefault()
    if !@runtips_view
      @runtips_view = new Smorodina.Views.ObjectRuntipsView
      @runtips_view.start()

