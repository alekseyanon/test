#= require ../collections/landmarks
#= require ./base_view

class Smorodina.Views.SearchForm extends Smorodina.Views.Base
  el: '#mainSearch'
  events:
    'submit #mainSearchForm': 'submit'

  submit: (e) ->
    Backbone.trigger 'MainSearchFormSubmit'
    e.preventDefault()
