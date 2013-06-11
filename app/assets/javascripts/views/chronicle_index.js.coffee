class Smorodina.Views.ChronicleIndex extends Backbone.View
  template: JST['chronicle']

  initialize: ->
    @collection.on 'sync', @render, @
    @collection.fetch reset: true

  render: ->
    window.object_counter += @collection.length
    @days = _.groupBy(@collection.models, (model) ->
                                              return model.get('date')
                      )
    $('.backbone_chronicle_content').append @template(days: @days)
