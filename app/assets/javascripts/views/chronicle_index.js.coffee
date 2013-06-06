class Smorodina.Views.ChronicleIndex extends Backbone.View
  template: JST['chronicle']

  initialize: ->
    @collection.on 'sync', @render, @
    @collection.fetch reset: true

  render: ->
    console.log 'start groupping'
    @days = _.groupBy(@collection.models, (model) ->
                                              return model.get('date')
                      )
    console.log 'end grouping'
    console.log @days
    ### TODO: delete console log and change selector for chronicle
    $('.test1').append @template(days: @days)
