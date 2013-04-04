#= require ../collections/events
#= require ./base_view

class Smorodina.Views.EventSearchForm extends Smorodina.Views.Base
  el: '#eventSearchForm'
  events:
    'submit': 'onSubmit'

  onSubmit: (e) ->
    Backbone.trigger 'eventSearchFormSubmit'
    e.preventDefault()
