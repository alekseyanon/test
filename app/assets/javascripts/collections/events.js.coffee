#= require models/event

class Smorodina.Collections.Events extends Backbone.Collection
  model: Smorodina.Models.Event
  url: '/api/events/search'
  sortFunctions:
    date:
      asc: (item) ->
        Date.parse(item.get 'start_date')
      desc: (item) ->
        -Date.parse(item.get 'start_date')
    rating:
      asc: (item) ->
        item.get 'rating'
      desc: (item) ->
        -item.get 'rating'

  initialize: ->
    @changeSortFunction 'date', 'asc'
    Backbone.on 'eventsPageLoad', @loadEvents, @
    this.on 'reset', @group
    this.on 'sort', @group

  changeSortFunction: (prop, order) ->
    @comparator = _.bind(@sortFunctions[prop][order], @)
    @sortProp = prop

  sortCollection: (prop, order) ->
    @changeSortFunction(prop, order)
    @sort()

  loadEvents: ->
    @fetch()

  group: ->
    groupedByDate = _.groupBy @toJSON(), (event) ->
      moment(event.start_date).utc().format('dddd, D MMMM YYYY г.')
    groupedByDate = _.map groupedByDate, (events, date) ->
      date: date
      events : events
    @grouped =
      days: groupedByDate
      events: @toJSON()

  getGrouped: ->
    @grouped

  fetch: (options = {}) ->
    data =
      from: moment().format('YYYY-MM-DD'),
      to: moment().add('weeks', 1).format('YYYY-MM-DD')
    settings =
      reset: true
      data: {}

    options.data =_.extend(data, options.data)
    options = _.extend(settings, options)
    options.query = options.data
    super(options)
