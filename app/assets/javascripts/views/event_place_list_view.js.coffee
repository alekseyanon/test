#= require ./base_view

class Smorodina.Views.EventPlaceList extends Smorodina.Views.Base
  el: '.place_events'
  initialize: ->
    super()
    _.bindAll @
    @$content = @$ '.events_section__event_list'
    @$counter = @$ '.counter'
    @$allev = @$ '.all_events__link'
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

  addOne: (item) ->
    view = new Smorodina.Views.EventPlace(model: item)
    @$fragment = @$fragment.add view.render().el
