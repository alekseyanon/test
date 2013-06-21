class Smorodina.Views.Chronicle extends Backbone.View
  el: '.chronicle'
  template: JST['chronicle']
  events:
    'click .fetch-results__button a':     'add_items'
    'click .chronicle__search__all':      'add_items'
    'click .chronicle__search__objects':  'add_object_items'
    'click .chronicle__search__events':   'add_event_items'

  initialize: ->
    _.bindAll @
    @last_day = 0
    @content_type = 'all'
    @$chronicle_elem = $('.backbone_chronicle_content')
    @collection.on('sync', @render, @)
    @collection.fetch()

  render: ->
    @addAll()
    @

  addAll: ->
    @days = _.groupBy @collection.models, (model) ->
                                            model.get('creation_date')
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
    @collection.fetch(data:
                        go_offset: @collection.go_offset
                        event_offset: @collection.event_offset)

  add_object_items: (e) ->
    e.preventDefault()
    @content_type = 'geo_object'
    @collection.fetch(data:
                        go_offset: @collection.go_offset
                        event_offset: @collection.event_offset
                        type: @content_type)
    add_items()

  add_event_items: (e) ->
    e.preventDefault()
    @collection.fetch({data: {go_offset: @collection.go_offset, event_offset: @collection.event_offset}})
