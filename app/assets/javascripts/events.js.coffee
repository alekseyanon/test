# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

Smorodina.Utils.onRoute '/events', ->
  events = new Smorodina.Collections.Events
  events.fetch()

  $ ->
    new Smorodina.Views.EventList(collection:events)

###jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).closest('fieldset').remove()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    form = $(this)
    regexp = ///#{form.data 'id' }///g
    form.before form.data('fields').replace(regexp, time)
    event.preventDefault()###
