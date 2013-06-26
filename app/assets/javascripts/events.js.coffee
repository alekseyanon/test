#= require ./routers/event_router
#= require collections/events

Smorodina.Pages.Events = ->
  events = new Smorodina.Collections.Events

  $ ->
    Smorodina.Utils.History.stop()
    new Smorodina.Routers.EventRouter
    new Smorodina.Views.EventSearchForm(collection:events)
    new Smorodina.Views.EventList(collection:events)
    new Smorodina.Views.SearchFetch(collection:events)
    new Smorodina.Views.SearchResultsPanel(collection:events)
    new Smorodina.Views.SearchEmpty(collection:events)

    Backbone.history.start(pushState: true, root: '/events')

  $ ->
    $('#eventSearchFormInput').autocomplete
      source: ( request, response ) ->
        $.getJSON('/api/events/search', autocomplete: request.term, response)
      minChars: 2
      select: (event, ui) ->
        event.preventDefault()
        $('#eventSearchFormInput').val(ui.item.label)
