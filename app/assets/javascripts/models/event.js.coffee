class Smorodina.Models.Event extends Backbone.Model
  initialize: ->
    @set('date_range', moment(@get 'start_date').format('D MMMM') + ' - ' + moment(@get 'end_date').format('D MMMM'))
