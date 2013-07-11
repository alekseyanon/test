class Smorodina.Views.SpamToView extends Smorodina.Views.Base
  
  tagName: 'span'

  template: JST['spam_to']

  initialize: ->
    _.bindAll @
    @complaint = @options.complaint

  render: ->
    @$el.html @template(complaint: @complaint)
    @$('.tooltip_init').tooltip()
    @
