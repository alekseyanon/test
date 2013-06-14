#= require ./base_view

class Smorodina.Views.EventPlaceList extends Smorodina.Views.Base
  el: '.place_events'
  initialize: ->
    super()
    _.bindAll @
    @$content = @$el.find '.events_section__event_list'
    @$counter = @$el.find '.counter'
    @$allev = @$el.find '.all_events__link'
    @$allev.on 'click', @renderAll
    @collection.on 'sync reset', @render
    @collection.fetch()
    
  render: ->
    @$fragment = $(null);
    @$counter.html @collection.length
    if @collection.length
      add = @addOne
      @collection.each (item, i) ->
        add(item) if i<2
      @show()
    else
      @hide()
    @$content.html @$fragment
  
  renderAll: (e) ->
    e.preventDefault()
    @$fragment = $(null);
    @$counter.html @collection.length
    if @collection.length
      @collection.each @addOne
      @show()
    else
      @hide()
    @$content.html @$fragment

  addOne: (l) ->
    view = new Smorodina.Views.EventPlace(model: l)
    @$fragment = @$fragment.add view.render().el
    