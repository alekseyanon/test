#= require ./base_view

class Smorodina.Views.ObjectsMap extends Smorodina.Views.Base
  initialize: ->
    super()
    @render()

  render: ->
    @$el.text 'map here'

class Smorodina.Views.LocationSelector extends Smorodina.Views.Base
  initialize: ->
    super()
    new Smorodina.Views.ObjectsMap el: @$ '.location-selector__map__content'
    @render()


  render: ->
    #@$el.text 'OK'
    @