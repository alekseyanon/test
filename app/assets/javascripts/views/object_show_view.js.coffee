class Smorodina.Views.ObjectShow extends Backbone.View
  el: '.obj_show_page'

  events:
    'click .obj_descr__text__descr__how_to_reach a.runtip_switcher' : 'init_runtips'

  object_id: 0

  initialize: ->
    _.bindAll @
    @object_id = @options.object_id
    @review_model = new Backbone.Model()
    @reviews_collection = new Backbone.Collection @model, url: "/api/objects/#{@object_id}/reviews.json"
    @reviews_view = new Smorodina.Views.ReviewsListView collection: @reviews_collection
    @$el.find('.obj_descr__responces').html @reviews_view.el

  init_runtips: (e)-> 
    e.preventDefault()
    if !@runtips_view
      @runtip_model = new Smorodina.Models.Runtip()
      @runtips_collection = new Smorodina.Collections.Runtips @model, url: "/api/objects/#{@object_id}/runtips.json"
      @runtips_view = new Smorodina.Views.ObjectRuntipsView collection: @runtips_collection

