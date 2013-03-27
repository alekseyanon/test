#= require ../collections/landmarks
#= require ./base_view

class Smorodina.Views.SearchForm extends Smorodina.Views.Base
  el: '#mainSearch'
  events:
    'submit #mainSearchForm': 'submit'

  submit: (e) ->
    Backbone.trigger 'mainSearchFormSubmit'
    e.preventDefault()
