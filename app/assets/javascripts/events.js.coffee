#= require ./routers/event_router
#= require ./collections/events

Smorodina.Pages.Events = ->

  events = new Smorodina.Collections.Events
  events.fetch({ reset: true })

  $ ->
    new Smorodina.Views.EventList(collection:events)
    new Smorodina.Utils.History.restart(Smorodina.Routers.EventRouter, { root: 'events' })
