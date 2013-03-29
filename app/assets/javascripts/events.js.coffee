# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

Smorodina.Utils.onRoute '/events', ->
  events = new Smorodina.Collections.Events
  events.fetch({ reset: true })

  $ ->
    new Smorodina.Views.EventList(collection:events)
