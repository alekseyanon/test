class Smorodina.Views.Chronicle extends Backbone.View
  el: '.chronicle'
  template: JST['chronicle']
  events:
    'click .fetch-results__button a':  'add_items'

  initialize: ->
    _.bindAll @
    @last_day = 0
    @$chronicle_elem = $('.backbone_chronicle_content')
    @collection.on('sync', @render, @)
    @collection.fetch()

  render: ->
    @addAll()
    @

  addAll: ->
    @days = _.groupBy @collection.models, (model) ->
                                            model.get('date')
    dates = _.keys(@days)
    first_date = dates[0]
    if @last_day == first_date
      elem = $('.chronicle__section').last()
      elem.append JST['chronicle_day_items'](objects: @days[first_date])
      delete @days[first_date]
    @$chronicle_elem.append @template(days: @days)
    @last_day = _.last(dates)

  add_items: (e) ->
    e.preventDefault()
    @collection.fetch({data: {offset: @collection.offset}})
