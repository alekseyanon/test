class Smorodina.Views.Chronicle extends Backbone.View
  el: '.chronicle'
  events:
    'click #abracadabra':  'init_items'
    'click .fetch-results__button a':  'init_items'

  initialize: ->
    _.bindAll @
    @chronicle_collection = new Smorodina.Collections.ChronicleItems
    @chronicle_view = new Smorodina.Views.ChronicleIndex collection: @chronicle_collection
    @page = 0

  init_items: (e) ->
    e.preventDefault()
    @page += 1
    @chronicle_model = new Backbone.Model()
    @chronicle_coll = new Backbone.Collection @chronicle_model, url: "/api/chronicles/show.json?page=#{@page}"
    @chronicle_v = new Smorodina.Views.ChronicleIndex collection: @chronicle_coll
    @$el.find('.cccc').html @chronicle_v.el
