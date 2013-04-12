#= require ./base_view

class Smorodina.Views.SearchResultsPanel extends Smorodina.Views.Base
  el: '#searchResultsPanel'
  initialize: ->
    super()
    @collection.on 'reset', @render

    @$('.sort-group')
      .sortGroup(
        controls: [
          { type: 'date', text: 'Дате' }
          { type: 'rating', text: 'Рейтингу' }
        ]
        selected: 'date')
      .on('sort', @sort)

  render: ->
    if @collection.length then @show() else @hide()

  sort: (e, data) ->
    @collection.sortCollection(data.type, data.order)
