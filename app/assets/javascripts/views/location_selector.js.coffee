#= require ./base_view

class Smorodina.Views.LocationSelector extends Smorodina.Views.Base
  initialize: ->
    super()
    @render()

  render: ->
    @$el.text 'OK'
    @