class Smorodina.Views.SpamToView extends Smorodina.Views.Base
  template: JST['spam_to']

  initialize: ->
    _.bindAll @
    @complaint = @options.complaint
    @render()

  render: ->
    @$el.html @template(complaint: @complaint)
    @$('.tooltip_init').tooltip()
    @
