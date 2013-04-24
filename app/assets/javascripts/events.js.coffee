#= require ./routers/event_router
#= require ./collections/events

Smorodina.Pages.Events = ->

  events = new Smorodina.Collections.Events
  events.fetch({ reset: true })

  $ ->
    new Smorodina.Views.EventList(collection:events)
    new Smorodina.Utils.History.restart(Smorodina.Routers.EventRouter, { root: 'events' })
    $('form').on 'click', '.remove_fields', (event) ->
      $(this).prev('input[type=hidden]').val('1')
      $(this).closest('fieldset').hide()
      event.preventDefault()

    $('form').on 'click', '.add_fields', (event) ->
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).before($(this).data('fields').replace(regexp, time))
      event.preventDefault()

    $('form').on 'click', '.add_input', ->
      time = new Date().getTime()
      $(this).parent().append "<input class='string' id='video_url_#{time}' name='video_urls[#{time}]' size='50' type='text'><br>"
